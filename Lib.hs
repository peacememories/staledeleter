module Lib
(
    getOld
)
where

import System.Directory
import System.PosixCompat.Files
import System.Posix.Types
import System.FilePath.Posix
import Data.Time
import Data.Time.Clock.POSIX
import Control.Monad

getOld :: EpochTime -> FilePath -> IO [FilePath]
getOld age dir = do
    now <- getEpochNow
    getRealDirContents dir >>= (filterM (filterFun (now - age)))

filterFun :: EpochTime -> FilePath -> IO Bool
filterFun refTime file = (getAccTime file) >>= return . (refTime >)

getAccTime :: FilePath -> IO EpochTime
getAccTime path = do
    isDir <- doesDirectoryExist path
    if isDir
    then
        getRealDirContents path >>=
        sequence . (map getAccTime) >>=
        return . maximum
    else
        getFileStatus path >>= return . accessTime

getEpochNow :: IO EpochTime
getEpochNow = getCurrentTime >>= (return . fromIntegral . toSecs)
    where
        toSecs :: UTCTime -> Int
        toSecs = round . utcTimeToPOSIXSeconds

getRealDirContents :: FilePath -> IO [FilePath]
getRealDirContents path = getDirectoryContents path >>=
                          return . (map (path</>)) . (filter (/="..")) . (filter (/="."))
