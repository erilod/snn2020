import * as Mithril from "mithril"
import m from "mithril"
export {ladda, artiklar, loadblock, setLoadblock }


//Fyller på med artiklar
let artiklar = []

//En block för att förhindra att fler artiklar laddas vid scrollning innan sidan ritats på nytt...
let loadblock = false

//set för loadblock.
function setLoadblock(val:boolean) {
    loadblock = val
}

//Typ av artikelladdning

// När man vill ladda flera artiklar. Utgår fån längden och laddar.
function ladda(typ: string) {

    //Snabbladdar från localStorage vid ny sidladdning. Alt inkrementell laddning.
    if (typ !== "scroll") {
        //Inte inkrementell. Prövning görs om vi ska ladda från server...
        //...men först så laddar vi det som finns på local storage bara för att få snabbt innehåll på sidan.
        artiklar = JSON.parse(localStorage.getItem("artiklar")) || [] //om local storage är tomt undviker vi null
            Mithril.redraw()

        //Kolla mot servern om det finns uppdaterade annars ladda från local storage
        Mithril.request({
            url: "https://www.sydnarkenytt.se/json/last",
            background : true //ritar inte om sidan efter kollen.

        }).then((resp) => {
            let senastuppdat = resp[0].edit_date

            if (Number(localStorage.getItem("lastupdate")) < senastuppdat) {
                console.log("Dags att uppdatera")

                //Det finns nya låtoss ladda dem!
                let url = "https://www.sydnarkenytt.se/json/etta/P1"
                m.request({
                    url: url,
                }).then(resp => {
                    //Splicar artikelarrayen från grunden
                    artiklar.splice(0, artiklar.length, ...resp)
                    localStorage.setItem("artiklar", JSON.stringify(artiklar))
                    localStorage.setItem("lastupdate", senastuppdat)
                })
            }
        })
    } else {
        // Vid inkrementell alddning. Fylls arrayen bara på
        let url = "https://www.sydnarkenytt.se/json/etta/P" + artiklar.length
        m.request({
            url: url
        }).then(resp => {
            console.log(resp)
            artiklar.splice(artiklar.length, 0, ...resp)
            localStorage.setItem("artiklar", JSON.stringify(artiklar))
        })
    }
}

//Ladda nytt när man scrollat en bit ner.
//För att minimera att flera sidor laddas in innan nya har hämtats så switchar vi på "loadblock". Blocket tas bort efter uppdaterad view...
window.onscroll = () => {
    console.log(loadblock)
    if (!loadblock) {
        let { top, height } = document.body.getBoundingClientRect()
        if (top + height <= 8000) {
            loadblock = true
            ladda("scroll")
        }
    }
}