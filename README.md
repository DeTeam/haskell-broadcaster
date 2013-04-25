## Haskell TCP->WS broadcasting app example

Just a little example of how you can write a TCP + WS server with broadcasting messages to browser (or any other) clients.

It uses:
* websockets
* network

That's it.

*I tried to make another version with HTTP -> WS, but dealing with Warp's ByteString agains WS' Text took too much time.*