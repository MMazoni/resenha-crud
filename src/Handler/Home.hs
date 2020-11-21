{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Text.Julius (RawJS (..))


getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        let (queryFormId, queryInputId, booksListId) = queryIds
        setTitle "MyLibrary"
        $(widgetFile "homepage")


queryIds :: (Text, Text, Text)
queryIds = ("js-queryForm", "js-createQueryInput", "js-bookList")
