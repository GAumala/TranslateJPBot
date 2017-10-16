{-# LANGUAGE DeriveGeneric #-}

module Data.Telegram.WebhookResponse (WebhookResponse (WebhookResponse)) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import GHC.Generics

data WebhookResponse = WebhookResponse {
  method :: Text,
  chat_id :: Int,
  text :: Text,
  parse_mode :: Text
} deriving (Show, Eq, Generic)


instance ToJSON WebhookResponse
instance FromJSON WebhookResponse
