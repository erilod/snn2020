include karax / prelude
import dom, jsconsole, asyncjs
import moduler/ [ladda, routerstate]
import komponenter/ [sidhuvud/sidhuvud, artikelspalt/artikelspalt]
import karax / vstyles


proc root (data: RouterData): VNode =
    result = buildHtml(tdiv):
        sidhuvud(counter)
        tdiv(class = "section mainarea"):
            tdiv(class = "s-100 m-100 l-100 container"):
                artikelspalt()

setRenderer root

proc loadpage () {.async.} =
    await preLadda()
    await ladda()

discard loadpage()
