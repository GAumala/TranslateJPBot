{-# LANGUAGE OverloadedStrings #-}

module Data.JMdictEntryTreeSpec where

import Data.Maybe
import Data.RedBlackTree
import Data.JMdictEntryTree (jmdictEntryTreeFromFile, lookupWord)
import Test.Hspec
import Data.Text (Text)

spec ::Spec
spec =
  describe "jmdictEntryTreeFromFile" $
    it "returns a tree with an entry for 'かえる'" $ do
      tree <- jmdictEntryTreeFromFile "JMdict_e.xml"
      let query = "かえる" :: Text
      let result = lookupWord tree query
      result `shouldSatisfy` isJust
