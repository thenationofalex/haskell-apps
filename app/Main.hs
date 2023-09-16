{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Either
import Data.Text
import Configuration.Dotenv (loadFile, defaultConfig)
import Network.Wreq
import System.Environment
import qualified Data.ByteString.Char8 as BS

main :: IO ()
main = do
    loadFile defaultConfig

    token <- getEnv "GH_TOKEN"
    webhookUrl <- getEnv "WEBHOOK_URL"

    let bearerToken = "Bearer " <> BS.pack token

    putStrLn $ "Token " ++ BS.unpack bearerToken

    let endPoint = "https://api.github.com/repos/thenationofalex/haskell-apps/pulls"
    
    let opts = defaults & header "Accept" .~ ["application/vnd.github+json"]
                        & header "Authorization" .~ [bearerToken]
                        & header "X-Github-Api-Version" .~ ["2022-11-28"]


    putStrLn ("\nFetching PRs from " ++ endPoint)

    response <- getWith opts endPoint

    -- putStrLn $ "Status Code: " ++ show (response ^. responseStatus . statusCode)
    -- putStrLn $ "Response Body: " ++ show (response ^. responseBody)    

    if response ^. responseStatus . statusCode == 201
        then putStrLn "Success"
        else error "Opps" 

    let msg = "The following PRs are ready for review 🔬\n\n"

    putStrLn msg