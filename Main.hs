import Control.Monad
import Control.Exception
import System.Environment
import System.Directory

import Lib

main = do
    (path:time:_) <- getArgs
    files <- getOld (read time) path
    print files
    sequence $ map deleteNode files

deleteNode :: FilePath -> IO ()
deleteNode path = catch (do
    isDir <- doesDirectoryExist path
    if isDir
    then
        removeDirectoryRecursive path
    else
        removeFile path
    ) ((putStrLn . show) :: (SomeException -> IO ()))
