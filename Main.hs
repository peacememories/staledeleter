import Control.Monad
import Control.Exception
import System.Environment
import System.Directory

import Lib
import TimeParse
import Text.Parsec

main = do
    (path:time:_) <- getArgs
    case (parse timeParser "Input" time) of 
        Right t -> do
            files <- getOld t path
            print files
            sequence $ map deleteNode files
            return ()
        Left error -> putStr $ show error

deleteNode :: FilePath -> IO ()
deleteNode path = catch (do
    isDir <- doesDirectoryExist path
    if isDir
    then
        removeDirectoryRecursive path
    else
        removeFile path
    ) ((putStrLn . show) :: (SomeException -> IO ()))
