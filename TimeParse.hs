module TimeParse (
    time
) where

import Text.ParserCombinators.Parsec
import Text.Parsec.Prim
import Text.Parsec.Combinator

import System.Posix.Types

time :: GenParser Char st EpochTime
time = do
    times <- sepBy timeEntity (char ' ')
    return $ foldr (+) 0 times

timeEntity :: GenParser Char st EpochTime
timeEntity = undefined
