module TimeParse (
    timeParser
) where

import Text.ParserCombinators.Parsec
import Text.Parsec.Prim
import Text.Parsec.Combinator
import Control.Applicative hiding ((<|>))

import System.Posix.Types

data TimeUnit = Seconds | Minutes | Hours | Days | Weeks

correctionFactor :: TimeUnit -> Integer
correctionFactor Seconds = 1
correctionFactor Minutes = correctionFactor Seconds * 60
correctionFactor Hours = correctionFactor Minutes * 60
correctionFactor Days = correctionFactor Hours * 24
correctionFactor Weeks = correctionFactor Days * 7

timeParser :: GenParser Char st EpochTime
timeParser = do
    times <- sepBy timeEntity (char ' ')
    return $ foldr (+) 0 times

timeEntity :: GenParser Char st EpochTime
timeEntity = do
    num <- integer
    char ' '
    factor <- correctionFactor <$> timeUnit
    return $ fromIntegral $ num * factor

integer = rd <$> many1 digit
    where rd = read :: String -> Integer

timeUnit :: GenParser Char st TimeUnit
timeUnit = (string "seconds" >> return Seconds)
    <|> (string "minutes" >> return Minutes)
    <|> (string "hours" >> return Hours)
    <|> (string "days" >> return Days)
    <|> (string "weeks" >> return Weeks)
