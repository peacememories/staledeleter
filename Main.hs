import Control.Monad
import System.Environment
import System.Directory

import Lib

main = do
    (path:time:_) <- getArgs
    files <- getOld (read time) path
    print files
    sequence $ map deleteNode files

deleteNode :: FilePath -> IO ()
deleteNode path = do
    isDir <- doesDirectoryExist path
    if isDir
    then
        removeDirectory path
    else
        removeFile path
