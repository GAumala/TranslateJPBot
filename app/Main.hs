import Text.XML.JMdictParser

main = parseJMdictFile "JMdict_e.xml" >>= print
