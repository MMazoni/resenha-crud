{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cadastro where

import Import

formUsu :: Form (Usuario, Text)
formUsu = renderBootstrap $ (,)
    <$> (Usuario
        <$> areq textField "Nome: " Nothing
        <*> areq emailField "E-mail: " Nothing
        <*> areq passwordField "Senha: " Nothing)
    <*> areq passwordField "Digite Novamente: " Nothing


getCadastroR :: Handler Html
getCadastroR = do
    (widget,_) <- generateFormPost formUsu
    msg <- getMessage
    defaultLayout $ do
        $(widgetFile "usuario")


postCadastroR :: Handler Html
postCadastroR = do
    ((result,_),_) <- runFormPost formUsu
    case result of
        FormSuccess (usuario,verifica) -> do
            if (usuarioSenha usuario == verifica) then do
                _ <- runDB $ insert usuario
                setMessage [shamlet|
                    <div .alert.alert-success role="alert">
                        Cadastro com sucesso.
                |]
                redirect CadastroR
            else do
                setMessage [shamlet|
                    <div .alert.alert-danger role="alert">
                        Sem sucesso no cadastro.
                |]
                redirect CadastroR
        _ -> redirect HomeR