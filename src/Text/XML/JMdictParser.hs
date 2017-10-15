{-# LANGUAGE OverloadedStrings #-}

module Text.XML.JMdictParser (parseJMdictFile, JMdictEntry (JMdictEntry)) where

import Data.Maybe

import Control.Monad.Trans.Resource
import Data.Conduit (Consumer, Sink, runConduitRes, (.|))
import Data.Text (Text, unpack, concat)
import Data.XML.Types (Event)
import Text.XML.Stream.Parse

data JMdictEntry = JMdictEntry {
  entryId :: Int,
  kanjiElements :: [Text],
  readingElements :: [Text],
  senseElements :: [Text]
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

parseEntry :: MonadThrow m => Consumer Event m (Maybe JMdictEntry)
parseEntry = tag' "entry" ignoreAttrs $ \ () -> do
  entryId <- force "ent_seq is required" (tagNoAttr "ent_seq" content)
  parsedKanjiElements <- many parseKanjiElement
  parsedReadingElements <- many parseReadingElement
  parsedSenseElements <- many parseSenseElement
  return $ JMdictEntry (read $ unpack entryId)
                 parsedKanjiElements
                 parsedReadingElements
                 (Prelude.concat parsedSenseElements)

parseJMdictFile :: String -> IO [JMdictEntry]
parseJMdictFile jmdictFileName = runConduitRes
                               $ parseFile def jmdictFileName
                               .| force "JMdict required" parseJMdict
                               where parseJMdict = tagNoAttr "JMdict"
                                                   (many parseEntry)
