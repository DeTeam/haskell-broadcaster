module Broadcaster.Internal where

import Broadcaster.Types

import Control.Concurrent
import Control.Monad
import Control.Concurrent.Async (async, waitAny)



withServerState :: ( Client -> ServerState -> ServerState ) -> ( MServerState -> Client -> IO () )
withServerState f = \ms c -> modifyMVar_ ms $ return . (f c) 

addClient client clients = client : clients
ioAddClient = withServerState addClient

removeClient client = filter (/= client)
ioRemoveClient = withServerState removeClient


splitIO :: [IO ()] -> IO ()
splitIO actions = do
  asyncs <- mapM async actions
  waitAny asyncs
  return ()

newServerState :: IO (MVar ServerState)
newServerState = newMVar []

createClient = Client

actionWithServer :: MServerState -> ( ServerState -> IO () ) -> IO ()
actionWithServer ms action = do
  withMVar ms action
  return ()