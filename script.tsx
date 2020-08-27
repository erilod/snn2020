import m from "mithril"
import * as Mithril from "mithril"
import * as Ladda from "./moduler/laddartiklar"
import {Artiklar} from "./komponenter/artiklar"
@import "./styles.css"


//Testar en komponent till och routing
let Nyheter = {
    view: () => {
        return (
            <div>
                <m.route.Link href="/nyheter">Nyheter</m.route.Link> <m.route.Link onclick={()=>{Ladda.ladda()}} href="/artiklar">Artiklar</m.route.Link>

                <h1>Testar hur routingen funkar</h1>
            </div>
        )
    }
}

//Testar route
Mithril.route.prefix = ""
Mithril.route(document.body, "/artiklar", {
    "/nyheter": Nyheter,
    "/artiklar": Artiklar
})

//Inledande laddning av artiklar
Ladda.ladda()




