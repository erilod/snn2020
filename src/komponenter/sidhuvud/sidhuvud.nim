include karax / prelude

proc sidhuvud* (inp: int): VNode =
    return buildHtml(tdiv):
        tdiv(id = "sidhuvud"):
            h1: text "Scroll: " & $inp
