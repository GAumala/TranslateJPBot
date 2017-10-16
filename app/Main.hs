import Data.Default
import Data.JMdictEntryTree
import Network.Wai.Middleware.RequestLogger
import Web.JPBotScottyServer
import Web.Scotty

main = do
  let telegramSecretToken = "MYTOKEN"
  putStrLn "Constructing tree..."
  tree <- jmdictEntryTreeFromFile "JMdict_e.xml"
  putStrLn "Starting server..."
  logger <- mkRequestLogger def { outputFormat = Apache FromHeader }
  scotty 4000 $ do
    middleware logger
    routes telegramSecretToken tree
