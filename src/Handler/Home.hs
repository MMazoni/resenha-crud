{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import


getHomeR :: Handler Html
getHomeR = do
    resenhas <- runDB $ selectList [] [Asc ResenhaId]
    defaultLayout $ do
        setTitle "MyLibrary"
        $(widgetFile "homepage")