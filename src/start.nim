include karax / prelude
import dom, jsconsole, asyncjs
import moduler / globalstate, moduler/ladda
import komponenter/ [sidhuvud/sidhuvud, artikelspalt/artikelspalt, raknare/raknare]
import karax / vstyles

var data = DataState(titel: "Min titel", ingress: "Min ingress")

proc root (): VNode =
    result = buildHtml(tdiv):
        tdiv: text data.titel
        sidhuvud(data)
        tdiv(class = "section mainarea"):
            tdiv(class = "s-100 m-100 l-100 container"):
                artikelspalt()
                tdiv(class ="s-100 m-33 l-50"):
                    for i in 0..3:
                        raknare(i)

setRenderer root

proc loadpage () {.async.} =
    await preLadda()
    await ladda()

discard loadpage()
