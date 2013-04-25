module Broadcaster.Broadcast where

import Broadcaster.Types
import Broadcaster.Internal

import Data.Text.Lazy (Text)
import qualified Network.WebSockets as WS

sendMessageTo :: Text -> Client -> IO ()
sendMessageTo message client = WS.sendSink sink wsMessage
  where sink = getClientSink client
        wsMessage = WS.textData $ message

sendToEach :: Text -> ServerState -> IO ()
sendToEach message = mapM_ (sendMessageTo message)

broadcastMessageFor :: MServerState -> Text -> IO ()
broadcastMessageFor serverState message = actionWithServer serverState (sendToEach message)