include karax / prelude
import ../../ moduler / [ladda, globalstate]
import dom, jsconsole, macros


proc sidhuvud* (): VNode =

    var ort:string = $pullUrl()[1]

    return buildHtml(header(class="container", id="sidhuvud")):
        tdiv(class="l-20 m-25 s-25"):
            img(src="./grafik/logo.png", alt="Logotyp", class="logo")
        tdiv(class="l-80 m-75 s-75"):
            p: 
                text model.titel
                proc onclick(ev: Event, nd:VNode) =
                    model.titel = model.titel & $(model of Artikeldata)

        var knappklass = "ortmenyknapp" 

        var sydnarke, kumla, hallsberg, askersund, laxa, lekeberg: string = ""

        case ort
        of "sydnarke":
            sydnarke = " active"
        of "kumla":
            kumla = " active"
        of "hallsberg":
            hallsberg = " active"
        else:
            discard
        
        tdiv(class="l-100 m-100 s-100 menyrad clear"):
            a(href="/sydnarke", class=knappklass & sydnarke): text "Sydnärke"
            a(href="/kumla", class=knappklass & kumla): text "Kumla"
            a(href="/hallsberg", class=knappklass & hallsberg): text "Hallsberg"
            a(href="/askersund", class=knappklass): text "Askersund"
            a(href="/laxa", class=knappklass): text "Laxå"
            a(href="/lekeberg/test", class=knappklass): text "Test"

