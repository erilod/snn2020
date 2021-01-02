include karax / prelude
import ../../ moduler / [ladda, globalstate]
import dom, jsconsole, macros


proc sidhuvud* (stat: DataState): VNode =

    return buildHtml(header(class="container", id="sidhuvud")):
        tdiv(class="l-20 m-25 s-25"):
            img(src="./grafik/logo.png", alt="Logotyp", class="logo")
        tdiv(class="l-80 m-75 s-75"):
            p: 
                text stat.titel
                proc onclick(ev: Event, nd:VNode) =
                    stat.titel = stat.titel & $(stat of Artikeldata)



        var knappklass = "ortmenyknapp" 
        var active = " active"
        
        tdiv(class="l-100 m-100 s-100 menyrad clear"):
            a(href="/sydnarke", class=knappklass & active): text "Sydnärke"
            a(href="/kumla", class=knappklass): text "Kumla"
            a(href="/hallsberg", class=knappklass): text "Hallsberg"
            a(href="/askersund", class=knappklass): text "Askersund"
            a(href="/laxa", class=knappklass): text "Laxå"
            a(href="/lekeberg/test", class=knappklass): text "Test"

