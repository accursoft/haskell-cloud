import Control.Monad
import Data.Char
import System.IO
import System.IO.Error
import Network

main = do sock <- listenOn $ PortNumber 8080
          forever $ do (handle,_,_) <- accept sock
                       request <- hGetContents handle
                       when (any (null . dropWhile isSpace) (lines request)) $ void $ tryIOError $ hPutStr handle "HTTP/1.1 200 OK\r\n\r\nWelcome"
                       hClose handle
