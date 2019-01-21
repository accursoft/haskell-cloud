import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp

main = run 8080 $ \_ respond -> respond $ responseLBS
  status200
  [(hContentType, "text/plain")]
  "Welcome"