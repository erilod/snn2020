include karax / prelude

proc sidhuvud* (inp: int): VNode =
    proc mint (): string = 
        return if inp > 100: "Mint är väl gott" else: "Mint är inte gott"

    return buildHtml(tdiv):
        tdiv(id = "sidhuvud"):
            h1: text $inp
            p: text mint()