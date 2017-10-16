{-# LANGUAGE OverloadedStrings #-}

module Web.TelegramBot (createResponseFromPayload) where

import Data.JMdictEntryTree (EntryNode, lookupWord, showLookupResult)
import Data.RedBlackTree
import Data.Telegram.Chat
import Data.Telegram.Message
import Data.Telegram.Update
import Data.Telegram.WebhookResponse
import Data.Text (Text)

getChatIdFromMessage :: Message -> Int
getChatIdFromMessage = Data.Telegram.Chat.id . chat

translateReceivedMessageText :: RedBlackTree EntryNode -> Maybe Text ->
  Maybe Text
translateReceivedMessageText _ Nothing = Nothing
translateReceivedMessageText tree (Just messageText) =
  Just $ showLookupResult messageText (lookupWord tree messageText)

translateReceivedMessage :: RedBlackTree EntryNode -> Maybe Message ->
  Maybe Text
translateReceivedMessage _ Nothing = Nothing
translateReceivedMessage tree (Just receivedMessage) =
  translateReceivedMessageText tree (Data.Telegram.Message.text receivedMessage)

translationTelegramResponse :: Int -> Text -> WebhookResponse
translationTelegramResponse chatId translatedText =
  WebhookResponse "sendMessage" chatId translatedText "Markdown"

createResponseFromPayload :: RedBlackTree EntryNode -> Update ->
  Maybe WebhookResponse
createResponseFromPayload wordTree update =
  translationTelegramResponse <$> chatId <*> translation
  where receivedMessage = message update
        translation = translateReceivedMessage wordTree receivedMessage
        chatId = fmap getChatIdFromMessage (message update)
