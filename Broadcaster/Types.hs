module Broadcaster.Types where

import Control.Concurrent
import qualified Network.WebSockets as WS

type CurrentProtocol = WS.Hybi00

data Client = Client {
    getClientSink :: WS.Sink CurrentProtocol
  } deriving Eq

type ServerState = [Client]
type MServerState = MVar ServerState

type WSMonad = WS.WebSockets CurrentProtocol