include karax / prelude
import dom, jsconsole, asyncjs
import moduler/ [ladda]
import komponenter/ [sidhuvud/sidhuvud, artikelspalt/artikelspalt, raknare/raknare]
import karax / vstyles


proc root (data: RouterData): VNode =
    echo pathname
    result = buildHtml(tdiv):
        sidhuvud(data)
        tdiv(class = "section mainarea"):
            tdiv(class = "s-100 m-100 l-100 container"):
                if pathname == "/snn2020/docs/kumla":
                    p: text "Kumla"
                artikelspalt()
                tdiv(class ="s-100 m-33 l-50"):
                    raknare(0)
                    raknare(1)
                    raknare(3)
                    raknare(3)

setRenderer root

proc loadpage () {.async.} =
    await preLadda()
    await ladda()

discard loadpage()
