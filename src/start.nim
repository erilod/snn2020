include karax / prelude
import dom, jsconsole, asyncjs
import moduler/ [ladda, routerstate]
import komponenter/sidhuvud/sidhuvud


# Push och get  url
var counter*: int
proc scroll (): VNode =
    result = buildHtml(h3):
        text "scroll: " & $counter

var res: cstring

proc root (data: RouterData): VNode =
    if getUrl== "/v": 
        res = "Vänsterknapp"
    else: 
        res = "Högerknapp"

    result = buildHtml(tdiv):
        sidhuvud(counter)
        scroll()
        for artikel in artiklar:
            if not artikel.ettabild.isNil:
                img(src=artikel.ettabild)
            h2: 
                artikel.rubrik. verbatim()
            if artikel.rubrik.isNil:
                h2: 
                    if artikel.title.isNil: text "Laddar..." else: artikel.title.verbatim()
            p: 
                text artikel.ingress


window.addEventListener("scroll") do (ev:Event):
    counter += 1
    echo counter
    redraw()

setRenderer root

proc loadpage () {.async.} =
    await preLadda()
    await ladda()

discard loadpage()
