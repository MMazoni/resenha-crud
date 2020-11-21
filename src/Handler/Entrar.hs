{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Entrar where

import Import

formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing


getEntrarR :: Handler Html
getEntrarR = do
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do
        $(widgetFile "entrar")


postEntrarR :: Handler Html
postEntrarR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess ("root@root.com","root123") -> do
            setSession "_EMAIL" "root@root.com"
            redirect AdminR
        FormSuccess (email,senha) -> do
           usuario <- runDB $ getBy (UniqueEmail email)
           case usuario of
                Nothing -> do
                    setMessage [shamlet|
                        <div .alert.alert-danger role="alert">
                            E-mail não se encontra na base de dados.
                    |]
                    redirect EntrarR
                Just (Entity _ usu) -> do
                    if (usuarioSenha usu == senha) then do
                        setSession "_EMAIL" (usuarioEmail usu)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                            <div .alert.alert-danger role="alert">
                                Senha incorreta.
                        |]
                        redirect EntrarR
        _ -> redirect HomeR

getSairR :: Handler Html
getSairR = do
    deleteSession "_EMAIL"
    redirect HomeR


getAdminR :: Handler Html
getAdminR = do
    defaultLayout [whamlet|
        <h1>
            Bem-vindo, Administrador!
    |]