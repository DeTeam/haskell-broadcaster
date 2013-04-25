module Broadcaster.WebSockets (
  WS.runServer,
  wsAggregatorApp
) where

import Broadcaster.Types
import Broadcaster.Internal

import Control.Exception.Base (fromException)
import Control.Monad (forever)
import Control.Monad.IO.Class (liftIO)
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as LBS
import qualified Network.WebSockets as WS

import Network.WebSockets.Util.PubSub

wsAggregatorApp serverState r = do
  WS.acceptRequest r
  WS.getVersion >>= liftIO . putStrLn . ("Client version: " ++)
  sink <- WS.getSink
  let client = createClient sink
  liftIO $ ioAddClient serverState client
  wrapHeartBeat serverState client
  return ()

wrapHeartBeat serverState client = do
    flip WS.catchWsError catchDisconnect $ do
      forever $ do
        WS.receiveData :: WSMonad ByteString
        return ()
  where catchDisconnect e = case fromException e of
          Just WS.ConnectionClosed -> do
            liftIO $ do
              putStrLn "Client disconnected"
              liftIO $ ioRemoveClient serverState client
          _ -> return ()





