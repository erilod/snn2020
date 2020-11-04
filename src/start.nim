include karax / prelude
import dom, jsconsole, asyncjs
import ladda


# Push och get  url
var counter: int
proc scroll (): VNode =
    result = buildHtml(h3):
        text "scroll: " & $counter

proc sidhuvud(rub:string): VNode =
    result = buildHtml(tdiv):
        p:
            text rub

var res: cstring
proc root (data: RouterData): VNode =
    if getUrl== "/v": 
        res = "Vänsterknapp"
    else: 
        res = "Högerknapp"
    
    result = buildHtml(tdiv):
        sidhuvud("Ha en text")
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
        scroll()


window.addEventListener("scroll", proc (ev:Event) =
    counter += 1
    redraw()
)

window.addEventListener("popstate", proc (ev:Event) =
    redraw()

)

setRenderer root

proc loadpage () {.async.} =
    await preload()
    redraw()
    await ladda()
    redraw()

discard loadpage()