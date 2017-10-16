{-# LANGUAGE DeriveGeneric #-}

module Data.Telegram.Payload (Payload (Payload), message) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Telegram.Message
import GHC.Generics

data Payload = Payload {
  update_id :: Int,
  message :: Maybe Message
} deriving (Show, Eq, Generic)

instance ToJSON Payload
instance FromJSON Payload
