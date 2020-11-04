include karax / prelude
import ../../moduler/routerstate
import dom,jsconsole


proc menyklick(ort:string, ev:Event) =
    ev.preventDefault()
    pushUrl(ort)



proc sidhuvud* (inp: int): VNode =
    return buildHtml(header(class="container", id="sidhuvud")):
        tdiv(class="l-20 m-25 s-25"):
            img(src="./grafik/logo.png")
        tdiv(class="l-80 m-75 s-75")

        var knappklass = "ortmenyknapp" 
        var active = " active"
        
        tdiv(class="l-100 m-100 s-100 menyrad clear"):
            a(onclick = proc (ev:Event, nd:VNode) = menyklick("", ev), href="", class=knappklass & active): text "Sydnärke"
            a(onclick = proc (ev:Event, nd:VNode) = menyklick("kumla", ev), href="", class=knappklass): text "Kumla"
            a(onclick = proc (ev:Event, nd:VNode) = menyklick("hallsberg", ev), href="", class=knappklass): text "Hallsberg"
            a(onclick = proc (ev:Event, nd:VNode) = menyklick("askersund", ev), href="", class=knappklass): text "Askersund"
            a(onclick = proc (ev:Event, nd:VNode) = menyklick("laxa", ev), href="", class=knappklass): text "Laxå"
            a(onclick = proc (ev:Event, nd:VNode) = menyklick("lekeberg", ev), href="", class=knappklass): text "Lekeberg"

