include karax / prelude
import ../../moduler/ladda
import dom, jsconsole, macros


template test(bdy:untyped): untyped =
    bdy


proc sidhuvud* (data:RouterData): VNode =

    return buildHtml(header(class="container", id="sidhuvud")):
        tdiv(class="l-20 m-25 s-25"):
            img(src="./grafik/logo.png")
        tdiv(class="l-80 m-75 s-75")

        var knappklass = "ortmenyknapp" 
        var active = " active"
        
        tdiv(class="l-100 m-100 s-100 menyrad clear"):
            a(href="#/sydnarke", class=knappklass & active): text "Sydnärke"
            a(href="#/kumla", class=knappklass): text "Kumla"
            a(href="#/hallsberg", class=knappklass): text "Hallsberg"
            a(href="#/askersund", class=knappklass): text "Askersund"
            a(href="#/laxa", class=knappklass): text "Laxå"
            a(href="#/lekeberg", class=knappklass): text "Lekeberg"

