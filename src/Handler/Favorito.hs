{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Favorito where

import Import
import Database.Persist.Sql

getListarFavoritoR :: Handler Html
getListarFavoritoR = do
    sess <- lookupSession "_EMAIL"
    case sess of
        Nothing -> redirect HomeR
        Just email -> do
            usu <- runDB $ getBy (UniqueEmail email)
            case usu of
                Nothing -> redirect HomeR
                Just (Entity uid usuario) -> do
                    let sql = "SELECT ??,?? FROM resenha \
                        \ INNER JOIN favorito on favorito.resenha = resenha.id \
                        \ WHERE favorito.usuario = ?"
                    favoritos <- runDB $ rawSql sql [toPersistValue uid] :: Handler [(Entity Favorito, Entity Resenha)]
                    defaultLayout $ do
                        $(widgetFile "favorito")


postFavoritoR :: ResenhaId -> Handler Html
postFavoritoR resenhaId = do
    sess <- lookupSession "_EMAIL"
    case sess of
        Nothing -> redirect HomeR
        Just email -> do
            usuario <- runDB $ getBy (UniqueEmail email)
            case usuario of
                Nothing -> redirect HomeR
                Just (Entity userId _) -> do
                    _ <- runDB $ insertEntity (Favorito userId resenhaId)
                    redirect HomeR