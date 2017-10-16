module Text.XML.JMdictParserSpec where

import Text.XML.JMdictParser
import Test.Hspec

spec ::Spec
spec =
  describe "parseJMdictFile" $
    it "parses a JMdict XML file and returns a non-empty list of entries" $ do
      entries <- parseJMdictFile "JMdict_e.xml"

      entries `shouldSatisfy` (> 0) . length
