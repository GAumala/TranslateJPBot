{-# LANGUAGE DeriveGeneric #-}

module Data.Telegram.Message (Message (Message), text, chat) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Telegram.Chat
import Data.Text (Text)
import GHC.Generics

data Message = Message {
  message_id :: Int,
  chat :: Chat,
  text :: Maybe Text
} deriving (Show, Eq, Generic)

instance ToJSON Message
instance FromJSON Message
