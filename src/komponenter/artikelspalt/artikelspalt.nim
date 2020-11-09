import ../../moduler/ [ladda]
include karax / prelude
import dom, jsconsole, asyncjs, strutils


proc ingress(ing: cstring): VNode =
    let wrds = ($ing).split()
    var nwrd = ""
    for i in 0..17:
        try: nwrd.add(wrds[i] & " ")
        except: break
    var outtext = nwrd
    result = buildHtml(p):
        text outtext & "..."
        proc onmouseover (ev:Event, nd:VNode) =
            outtext = $ing
            ev.target.innerText = outtext
        proc onmouseleave (ev:Event, nd:VNode) =
            outtext = $nwrd
            ev.target.innerText = outtext

proc artikelspalt* (): VNode =
    result = buildHtml(tdiv(class = "l-50 m-66 s-100 container")):
        var artcnt: int
        for artikel in artiklar:
            if artikel.status == "Undernyhet":
                artcnt += 1
                if not artikel.ettabild.isNil:
                    img(src=artikel.ettabild)
                h2: 
                    artikel.rubrik. verbatim()
                if artikel.rubrik.isNil:
                    h2: 
                        if artikel.title.isNil: text "Laddar..." else: artikel.title.verbatim()
                if not artikel.ingress.isNil:
                    ingress(artikel.ingress)
                p: text $artcnt
                p: text artikel.channel
