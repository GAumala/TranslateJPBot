import Data.JMdictEntryTree
import Web.JPBotScottyServer
import Web.Scotty

main = do
  let telegramSecretToken = "MYTOKEN"
  putStrLn "Constructing tree..."
  tree <- jmdictEntryTreeFromFile "JMdict_e.xml"
  putStrLn "Starting server..."
  scotty 4000 (routes telegramSecretToken tree)
