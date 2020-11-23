{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.ListarResenha where

import Import

getListarResenhaR :: Handler Html
getListarResenhaR = do
    resenhas <- runDB $ selectList [] [Asc ResenhaId]
    defaultLayout $ do
        $(widgetFile "listaresenha")

