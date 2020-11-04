
include karax/prelude
import dom

## Hanterar routerstatus
## 

var 
    pullUrl* {.importc: "window.location.pathname".} : cstring

proc pushUrl* (url:cstring) {.importjs: "window.history.pushState([],'state',#)" .} =
    redraw()

window.addEventListener("popstate", proc (ev:Event) =
    redraw()
)

