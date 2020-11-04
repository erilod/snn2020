include karax / prelude
import dom, jsconsole, asyncjs
import moduler/ [ladda, routerstate]
import komponenter/sidhuvud/sidhuvud
import karax / vstyles


# Push och get  url
var counter*: int
proc scroll (): VNode =
    result = buildHtml(h3):
        text "scroll: " & $counter

var res: cstring

proc root (data: RouterData): VNode =
    ##testar routingen
    var selstyle: VStyle

    if pullUrl== "/v": 
        res = "Vänsterknapp"
        selstyle = style((color, "red".cstring))
    elif pullUrl == "/h": 
        res = "Högerknapp"
        selstyle = style((color, "blue".cstring))
    else:
        res = "Nothing"
        selstyle = style((color, "yellow".cstring))
    result = buildHtml(tdiv):
        sidhuvud(counter)
        h4: text "testar routning:"
        p(style = selstyle): 
            text res
        button:
            proc onclick () =
                pushUrl("/v")
            text "Vänster"
        button:
            proc onclick () =
                pushUrl("/h")
            text "Höger"
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
