{-# LANGUAGE OverloadedStrings #-}

module Web.TelegramBotSpec where

import Data.Maybe
import Data.RedBlackTree
import Data.JMdictEntryTree (jmdictEntryTreeFromFile, lookupWord)
import Test.Hspec
import Data.Telegram.Chat
import Data.Telegram.Message
import Data.Telegram.Payload
import Data.Text (Text)
import Web.TelegramBot

spec ::Spec
spec =
  describe "createResponseFromPayload" $ do
    it "returns nothing if there is no message object" $ do
      let mockedPayload = Payload 1 Nothing

      let response = createResponseFromPayload emptyRedBlackTree mockedPayload

      response `shouldBe` Nothing

    it "returns nothing if there is no message text" $ do
      let mockedChat = Chat 1
      let mockedMessage = Message 1 mockedChat Nothing
      let mockedPayload = Payload 1 (Just mockedMessage)

      let response = createResponseFromPayload emptyRedBlackTree mockedPayload

      response `shouldBe` Nothing

    it "returns a just value if there is a just message text" $ do
      let mockedChat = Chat 1
      let mockedMessage = Message 1 mockedChat (Just "Hello Bot!")
      let mockedPayload = Payload 1 (Just mockedMessage)

      let response = createResponseFromPayload emptyRedBlackTree mockedPayload

      response `shouldSatisfy` isJust
