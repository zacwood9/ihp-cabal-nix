module Main where

import Application.Script.Prelude hiding ( run )
import IHP.ScriptSupport ( runScript )
import qualified Config

main = runScript Config.config run

run :: Script
run = do
    putStrLn "Hello World!"
