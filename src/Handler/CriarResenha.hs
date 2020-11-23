{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.CriarResenha where

import Import

formResenha :: Form (Text,Text,Text)
formResenha = renderDivs $ (,,)
    <$> areq textField "Titulo" Nothing
    <*> areq textField "Texto" Nothing
    <*> areq textField "Livro" Nothing
--    <*> areq intField "Autor" Nothing


getCriarResenhaR :: Handler Html
getCriarResenhaR = do
    sess <- lookupSession "_EMAIL"
    (widget, _) <- generateFormPost formResenha
    defaultLayout $ do
        $(widgetFile "resenha")


postCriarResenhaR :: Handler Html
postCriarResenhaR =  do
    ((res,_),_) <- runFormPost formResenha
    case res of
        FormSuccess (titulo,texto,livro) -> do
            sess <- lookupSession "_EMAIL"
            case sess of
                Nothing -> redirect HomeR
                Just email -> do
                    usuario <- runDB $ getBy (UniqueEmail email)
                    case usuario of
                        Just (Entity uid _) -> do
                            runDB $ insertEntity (Resenha titulo texto livro uid)
                            redirect ListarResenhaR
        _ -> redirect CriarResenhaR


-- error "Not yet implemented: postCriarResenhaR"

