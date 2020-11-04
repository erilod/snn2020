
include karax/prelude
import dom, strutils

## Hanterar routerstatus
## 
type Segments* = seq[cstring]

var pathname* {.importc: "window.location.pathname".} : cstring

proc pullUrl* (): Segments =
    return pathname.split("/")

proc pushUrl* (url:cstring) {.importjs: "window.history.pushState([],'state',#)" .} =
    redraw()

window.addEventListener("popstate", proc (ev:Event) =
    redraw()
)

