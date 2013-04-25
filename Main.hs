{-# LANGUAGE OverloadedStrings #-}

module Main where

import Broadcaster.Types
import Broadcaster.Internal
import Broadcaster.Broadcast
import Broadcaster.TCP
import Broadcaster.WebSockets


main :: IO ()
main = do
  serverState <- newServerState

  let 
      broadcast = broadcastMessageFor serverState
      wsApp     = wsAggregatorApp serverState
      tcpServer = broadcasterApp broadcast serverState tcpPort
      wsServer  = runServer "0.0.0.0" wsPort wsApp

  splitIO [tcpServer, wsServer]

  where tcpPort = 8000
        wsPort  = 9000