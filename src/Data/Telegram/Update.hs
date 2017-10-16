{-# LANGUAGE DeriveGeneric #-}

module Data.Telegram.Update (Update (Update), message) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Telegram.Message
import GHC.Generics

data Update = Update {
  update_id :: Int,
  message :: Maybe Message
} deriving (Show, Eq, Generic)

instance ToJSON Update
instance FromJSON Update
