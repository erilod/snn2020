include karax / prelude
import dom, jsconsole, asyncjs
import moduler/ [ladda, routerstate]
import komponenter/ [sidhuvud/sidhuvud, artikelspalt/artikelspalt]
import karax / vstyles


# Push och get  url
var counter*: int
proc scroll (): VNode =
    result = buildHtml(h3):
        text "scroll: " & $counter

var res: cstring

proc root (data: RouterData): VNode =
    result = buildHtml(tdiv):
        sidhuvud(counter)
        tdiv(class = "section mainarea"):
            tdiv(class = "s-100 m-100 l-100 container"):
                artikelspalt()

window.addEventListener("scroll") do (ev:Event):
    counter += 1
    echo counter
    redraw()

setRenderer root

proc loadpage () {.async.} =
    await preLadda()
    await ladda()

discard loadpage()
