import ../../moduler/ [ladda, routerstate]
include karax / prelude
import dom, jsconsole, asyncjs,strutils


proc artikelspalt* (): VNode =
    result = buildHtml(tdiv(class = "l-50 m-66 s-100 container")):
        for artikel in artiklar:
            if artikel.status == "Undernyhet":
                    if not artikel.ettabild.isNil:
                        img(src=artikel.ettabild)
                    h2: 
                        artikel.rubrik. verbatim()
                    if artikel.rubrik.isNil:
                        h2: 
                            if artikel.title.isNil: text "Laddar..." else: artikel.title.verbatim()
                    p: 
                        text artikel.ingress
                    p: text artikel.channel
