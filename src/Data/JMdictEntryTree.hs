{-# LANGUAGE OverloadedStrings #-}

module Data.JMdictEntryTree (EntryNode,
jmdictEntryTreeFromFile,
lookupWord,
printLookup,
showLookupResult) where

import Text.XML.JMdictParser

import Data.List (foldl')
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TextIO
import Data.RedBlackTree

data EntryNode = EntryNode {
  entryKey :: Text,
  mainEntry :: JMdictEntry,
  extraEntries :: [JMdictEntry]
} deriving Show

instance Eq EntryNode where
  (==) leftNode rightNode = entryKey leftNode == entryKey rightNode

instance Ord EntryNode where
  (<=) leftNode rightNode = entryKey leftNode <= entryKey rightNode

instance BinaryTreeNode EntryNode where
  mergeNodes (EntryNode key leftEntry extra) (EntryNode _ rightEntry _) =
    EntryNode key leftEntry (rightEntry:extra)

showEntryAsText :: JMdictEntry -> Text
showEntryAsText (JMdictEntry _ [] readings meanings) =
  T.intercalate "\n" [firstLine, secondLine]
  where firstLine = T.intercalate ", " readings
        secondLine = T.intercalate ", " meanings
showEntryAsText (JMdictEntry _ kanjis readings meanings) =
  T.intercalate "\n" [firstLine, secondLine, thirdLine]
  where firstLine = T.intercalate ", " kanjis
        secondLine = T.intercalate ", " readings
        thirdLine = T.intercalate ", " meanings

showEntryNodeAsText :: EntryNode -> Text
showEntryNodeAsText (EntryNode _ firstEntry extras) =
  T.intercalate "\n\n" entries
  where entries = map showEntryAsText (firstEntry:extras)

insertEntryToTree :: RedBlackTree EntryNode -> JMdictEntry -> RedBlackTree EntryNode
insertEntryToTree tree entry = foldl' insert tree nodes
  where JMdictEntry _ kanjis readings meanings = entry
        keys = kanjis ++ readings
        createEntryNode newKey = EntryNode newKey entry []
        nodes = map createEntryNode keys

jmdictEntryTreeFromFile :: String -> IO (RedBlackTree EntryNode)
jmdictEntryTreeFromFile filename = do
  entries <- parseJMdictFile filename
  return $ foldl' insertEntryToTree emptyRedBlackTree entries

lookupWord :: RedBlackTree EntryNode -> Text -> Maybe EntryNode
lookupWord tree word = Data.RedBlackTree.find tree targetNode
  where targetNode = EntryNode word (JMdictEntry 0 [] [] []) []

showLookupResult :: Text -> Maybe EntryNode -> Text
showLookupResult requestedWord lookupResult =
  fromMaybe notFoundMsg lookupResultText
  where notFoundMsg = T.concat [ "No entries match \"", requestedWord, "\"" ]
        lookupResultText = fmap showEntryNodeAsText lookupResult

printLookup :: RedBlackTree EntryNode -> String -> IO ()
printLookup tree queryString = TextIO.putStrLn queryResult
  where queryText = T.pack queryString
        queryResult = showLookupResult queryText (lookupWord tree queryText)
