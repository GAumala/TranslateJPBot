import Data.Default
import Data.JMdictEntryTree
import Data.Maybe (fromMaybe)
import Network.Wai.Middleware.RequestLogger
import System.Environment (lookupEnv)
import Web.JPBotScottyServer
import Web.Scotty

main = do

  telegramSecretToken <- fmap (fromMaybe "NOTOKEN") (lookupEnv "TELEGRAM_TOKEN")
  putStrLn "Constructing tree..."
  tree <- jmdictEntryTreeFromFile "JMdict_e.xml"
  putStrLn "Starting server..."
  logger <- mkRequestLogger def { outputFormat = Apache FromHeader }
  scotty 4000 $ do
    middleware logger
    routes telegramSecretToken tree
