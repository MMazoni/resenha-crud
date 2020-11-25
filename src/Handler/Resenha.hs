{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Resenha where

import Import


formResenha :: Maybe Resenha -> Form (Text,Textarea,Text)
formResenha mr = renderDivs $ (,,)
    <$> areq textField "Titulo" (fmap resenhaTitulo mr)
    <*> areq textareaField "Texto" (fmap resenhaTexto mr)
    <*> areq textField "Livro" (fmap resenhaLivro mr)


auxResenhaR :: Route App -> Maybe Resenha -> Handler Html
auxResenhaR rt mr = do
    sess <- lookupSession "_EMAIL"
    (widget, _) <- generateFormPost (formResenha mr)
    defaultLayout $ do
        $(widgetFile "resenha")


getResenhaR :: Handler Html
getResenhaR = auxResenhaR ResenhaR Nothing

postResenhaR :: Handler Html
postResenhaR =  do
    ((res,_),_) <- runFormPost (formResenha Nothing)
    case res of
        FormSuccess (titulo,texto,livro) -> do
            sess <- lookupSession "_EMAIL"
            case sess of
                Nothing -> redirect HomeR
                Just email -> do
                    usuario <- runDB $ getBy (UniqueEmail email)
                    case usuario of
                        Nothing -> redirect HomeR
                        Just (Entity uid _) -> do
                            _ <- runDB $ insertEntity (Resenha titulo texto livro uid)
                            redirect ListarResenhaUserR
        _ -> redirect ResenhaR


getEditarResenhaR :: ResenhaId -> Handler Html
getEditarResenhaR rid = do
    old <- runDB $ get404 rid
    auxResenhaR (EditarResenhaR rid) (Just old)

postEditarResenhaR :: ResenhaId -> Handler Html
postEditarResenhaR rid = do
    ((res,_),_) <- runFormPost (formResenha Nothing)
    case res of
        FormSuccess (titulo,texto,livro) -> do
            sess <- lookupSession "_EMAIL"
            case sess of
                Nothing -> redirect HomeR
                Just email -> do
                    usuario <- runDB $ getBy (UniqueEmail email)
                    case usuario of
                        Nothing -> redirect HomeR
                        Just (Entity uid _) -> do
                            let new = Resenha titulo texto livro uid
                            _ <- runDB (replace rid new)
                            redirect ListarResenhaUserR
        _ -> redirect HomeR


postDeletarResenhaR :: ResenhaId -> Handler Html
postDeletarResenhaR rid = do
    runDB $ deleteCascade rid
    redirect ListarResenhaUserR