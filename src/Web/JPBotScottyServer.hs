{-# LANGUAGE OverloadedStrings #-}

module Web.JPBotScottyServer (routes) where

import Data.JMdictEntryTree (EntryNode)
import Data.RedBlackTree
import Data.Telegram.Update
import Data.Telegram.WebhookResponse
import Data.Text (Text)
import Web.Scotty
import Web.TelegramBot

translateWord :: RedBlackTree EntryNode -> ActionM ()
translateWord wordTree = do
  payload <- jsonData :: ActionM Update
  let response = createResponseFromPayload wordTree payload
  maybeSendTelegramResponse response

maybeSendTelegramResponse :: Maybe WebhookResponse -> ActionM ()
maybeSendTelegramResponse Nothing = return ()
maybeSendTelegramResponse (Just response) = json response

routes :: String -> RedBlackTree EntryNode -> ScottyM ()
routes secretToken tree = post telegramWebhookPath (translateWord tree)
  -- Web hook path is just /<TELEGRAM_SECRET_TOKEN> 
  where telegramWebhookPath = literal $ "/telegram/" ++ secretToken
