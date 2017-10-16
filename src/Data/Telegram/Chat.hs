{-# LANGUAGE DeriveGeneric #-}

module Data.Telegram.Chat (Chat (Chat), Data.Telegram.Chat.id) where

import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics

data Chat = Chat {
  id:: Int
} deriving (Show, Eq, Generic)

instance ToJSON Chat
instance FromJSON Chat
