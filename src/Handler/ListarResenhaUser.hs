{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.ListarResenhaUser where

import Import
import Database.Persist.Sql

getListarResenhaUserR :: Handler Html
getListarResenhaUserR = do
    sess <- lookupSession "_EMAIL"
    case sess of
        Nothing -> redirect HomeR
        Just email -> do
            usu <- runDB $ getBy (UniqueEmail email)
            case usu of
                Nothing -> redirect HomeR
                Just (Entity uid usuario) -> do
                    let sql = "SELECT ??,?? FROM usuario \
                        \ INNER JOIN resenha ON resenha.usuarioid = usuario.id \
                        \ WHERE usuario.id = ?"
                    resenhas <- runDB $ rawSql sql [toPersistValue uid] :: Handler [(Entity Usuario, Entity Resenha)]
                    defaultLayout $ do
                        $(widgetFile "listaresenhauser")