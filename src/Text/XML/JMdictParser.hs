{-# LANGUAGE OverloadedStrings #-}

module Text.XML.JMdictParser (parseJMdictFile, Entry (Entry)) where

import Data.Maybe

import Control.Monad.Trans.Resource
import Data.Conduit (Consumer, Sink, runConduitRes, (.|))
import Data.Text (Text, unpack, concat)
import Data.XML.Types (Event)
import Text.XML.Stream.Parse

type KanjiElements = [Text]

type ReadingElements = [Text]

type SenseElements = [Text]

data Entry = Entry {
  entryId :: Int,
  readingElement :: ReadingElements,
  senseElement :: SenseElements,
  kanjiElement :: KanjiElements
} deriving Show

parseKanjiElement :: MonadThrow m => Consumer Event m (Maybe Text)
parseKanjiElement = tag' "k_ele" ignoreAttrs $ \ () -> do
  result <- force "keb is required" (tagNoAttr "keb" content)
  many $ ignoreTreeContent "ke_inf"
  many $ ignoreTreeContent "ke_pri"
  return result

parseReadingElement :: MonadThrow m => Consumer Event m (Maybe Text)
parseReadingElement = tag' "r_ele" ignoreAttrs $ \ () -> do
  result <- force "reb is required" (tagNoAttr "reb" content)
  ignoreTreeContent "re_nokanji"
  many $ ignoreTreeContent "re_restr"
  many $ ignoreTreeContent "re_inf"
  many $ ignoreTreeContent "re_pri"
  return result

parseSenseElement :: MonadThrow m => Consumer Event m (Maybe [Text])
parseSenseElement = tag' "sense" ignoreAttrs $ \ () -> do
  many $ ignoreTreeContent "stagk"
  many $ ignoreTreeContent "stagr"
  many $ ignoreTreeContent "pos"
  many $ ignoreTreeContent "xref"
  many $ ignoreTreeContent "ant"
  many $ ignoreTreeContent "field"
  many $ ignoreTreeContent "misc"
  many $ ignoreTreeContent "s_inf"
  many $ ignoreTreeContent "lsource"
  many $ ignoreTreeContent "dial"
  many $ tagNoAttr "gloss" content

parseEntry :: MonadThrow m => Consumer Event m (Maybe Entry)
parseEntry = tag' "entry" ignoreAttrs $ \ () -> do
  entryId <- force "ent_seq is required" (tagNoAttr "ent_seq" content)
  kanjiElement <- many parseKanjiElement
  readingElement <- many parseReadingElement
  senseElement <- many parseSenseElement
  return $ Entry (read $ unpack entryId) kanjiElement readingElement
                 (Prelude.concat senseElement)

parseJMdictFile :: String -> IO [Entry]
parseJMdictFile jmdictFileName = runConduitRes
                               $ parseFile def jmdictFileName
                               .| force "JMdict required" parseJMdict
                               where parseJMdict = tagNoAttr "JMdict"
                                                   (many parseEntry)
