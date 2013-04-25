module Broadcaster.TCP where


import Broadcaster.Types

import Prelude hiding (getContents)
import Control.Concurrent (forkIO)

import Data.Text.Lazy (pack)

import Network (listenOn, accept, withSocketsDo, PortID(..), Socket)
import System.IO (hSetBuffering, hGetContents, hPutStrLn, BufferMode(..), Handle)

broadcasterApp broadcast serverState port = withSocketsDo $ do
  sock <- listenOn $ PortNumber port
  sockHandler sock
  return ()

  where
      sockHandler sock = do
        (handle, _, _) <- accept sock
        forkIO $ processMessage handle
        sockHandler sock

      processMessage handle = do
        message <- hGetContents handle
        broadcast . pack $ message
        