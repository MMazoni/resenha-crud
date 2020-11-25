{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Database.Persist.Sql

getHomeR :: Handler Html
getHomeR = do
    --resenhas <- runDB $ selectList [] [Asc ResenhaId]
    let sql = "select ??, ?? \
            \ from resenha inner join usuario \
            \ on resenha.usuario_id = usuario.id"
    resenhas <- runDB $ rawSql sql []
    defaultLayout $ do
        setTitle "MyLibrary"
        $(widgetFile "homepage")