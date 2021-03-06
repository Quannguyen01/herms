module ReadConfig.Tests where

import           Test.Tasty              (TestTree, testGroup)
import           Test.Tasty.HUnit        (testCase)
import           Test.HUnit              ((@?))

import           ReadConfig
import qualified Text.Read as TR
import qualified Data.Yaml as Yaml
import           Types (Recipe)
import           Paths_herms hiding (getDataDir) -- This module is generated by cabal
import qualified Data.ByteString as BS

tests :: TestTree
tests = testGroup "ReadConfig"
    [ testCase "testParseConfig" $ do
        path <- getDataFileName "config.hs"
        contents <- readFile path
        (case TR.readEither (dropComments contents) :: Either String ConfigInfo of
          Left  _ -> False
          Right _ -> True) @? "Couldn't parse config file"
    , testCase "testParseRecipes" $ do
        path <- getDataFileName "recipes.yaml"
        contents <- BS.readFile path
        (case (Yaml.decodeEither contents :: Either String [Recipe]) of
                Left  err -> False @? "Couldn't parse recipes: " ++ err
                Right _   -> True  @? "Success")
    ]
