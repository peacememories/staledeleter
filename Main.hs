import Control.Monad
import System.Environment
import System.Directory
import System.PosixCompat.Files
import System.Posix.Types

main = liftM (!! 0) getArgs >>= putStr

getFileTimes :: FilePath -> IO [(FilePath, EpochTime)]
getFileTimes path = getDirectoryContents path >>= 

getAccTime :: FilePath -> IO EpochTime
getAccTime file = getFileStatus file >>= return . accessTime
