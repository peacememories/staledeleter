{-# LANGUAGE DeriveDataTypeable #-}
import Control.Monad
import Control.Exception
import System.Environment
import System.Directory
import System.Console.GetOpt
import Data.Typeable
import System.Posix.Types
import System.IO

import Lib
import TimeParse
import Text.Parsec

data InputException = InputException String deriving (Typeable)

instance Show InputException where
    show (InputException msg) = msg

instance Exception InputException

data Options = Options { optFolder :: FilePath
                       , optTime   :: EpochTime
                       }

options :: IO Options
options = do
    args <- getArgs
    case args of
        (path:timeStr) ->
            case (parse timeParser "stdin" (unwords timeStr)) of
                Right time -> return Options { optFolder = path
                                             , optTime = time
                                             }
                Left _ -> throw $ InputException "Wrong time format."
        otherwise -> throw $ InputException "Not enough arguments."

main = catch (options >>= deleteFiles) (\e -> printError e >> printUsage)

deleteNode :: FilePath -> IO ()
deleteNode path = catch (do
    isDir <- doesDirectoryExist path
    if isDir
    then
        removeDirectoryRecursive path
    else
        removeFile path
    ) ((putStrLn . show) :: (SomeException -> IO ()))

deleteFiles opts = do
    files <- getOld (optTime opts) (optFolder opts)
    print files
    sequence $ map deleteNode files
    return ()

printError :: InputException -> IO ()
printError e = hPutStrLn stderr $ show e

printUsage = do
    programName <- getProgName
    hPutStrLn stderr ("Usage:\n\
                    \    " ++ programName ++ " <path> <time>\n\
                    \Example:\n\
                    \    " ++ programName ++ " /path/to/folder 2 days 3 seconds")
