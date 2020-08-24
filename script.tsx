import m from "mithril"
import * as Mithril from "mithril"

// Fyller på med artiklar här
let artiklar = []

//För att inte fler laddningar ska göras när man fortsätter scrolla medan nya samtidigt läses in så flaggar vi om det. Den återställs till false när sidan är omritadoch nya kan läasas in vid scroll.
let loadblock = false

//För att skilja om laddning sker inkrementellt och arrayen ska fyllas på eller om det är en omladdning och man behöver kolla om man ska läsa in mer från servern
enum Laddtyp {
    reload,
    incremental,
}


// När man vill ladda flera artiklar. Utgår fån längden och laddar
function laddaArtiklar(typ: Laddtyp) {

    //Snabbladdar från localStorage vid ny sidladdning. Alt inkrementell laddning.
    if (typ !== Laddtyp.incremental) {
        //Inte inkrementell. Prövning görs om vi ska ladda från server...
        
        //...men först så laddar vi det som finns på local storage bara för att få snabbt innehåll på sidan.
        artiklar = JSON.parse(localStorage.getItem("artiklar"))
        Mithril.redraw()

        //Kolla mot servern om det finns uppdaterade annars ladda från local storage
        Mithril.request({
            url: "https://www.sydnarkenytt.se/json/last",
            background : true //ritar inte om sidan efter kollen.

        }).then((resp) => {
            console.log(resp)
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
            artiklar.splice(artiklar.length, 0, ...resp)
            localStorage.setItem("artiklar", JSON.stringify(artiklar))
        })
    }
}


//Två varianter med och utan JSX
// JSX med två komponenter En för varje artikelpuff som tar in data via attrs. En som renderar hela listan.  

let Artikel = {
    view: (vnode) => {
        return (
            <div>
                {vnode.attrs.src ? (<img style="height:169px" height="169px" width="300px" src={"https:" + vnode.attrs.src} />) : (<img src="fel.png" alt="Ingen bild" />)}
                <h1>{(vnode.attrs.title.replace(/&quot;/g, '"'))}</h1>
                <p>{vnode.attrs.ingress}</p>
            </div>)
    }
}

let Artiklar = {
    onupdate: () => {
        //Innehållet renderat. Flagga att det är ok att ladda vid scroll
        loadblock = false
    },
    view: () => {
        return (
            <div>
                <m.route.Link href="/nyheter">Nyheter</m.route.Link> <m.route.Link href="/artiklar">Artiklar</m.route.Link>
                {artiklar.map(artikel => {
                    return (
                        <Artikel title={artikel.title} key={artikel.id} ingress={artikel.ingress} src={artikel.ettabild} />
                    )
                })}
            </div>
        )
    }
}

// Motsvarande i ren js förutom att den inte är uppdelad i två komponenter
// Data direkt från globala artiklar
let Sidan = {
    view: () => {
        return m("div", [artiklar.map(artikel => {
            return m("div", { key: artikel.id }, [
                artikel.ettabild ? m("img", { style: { width: "300px" }, src: "https:" + artikel.ettabild }) : m(""),
                m("h1", artikel.title),
                m("p", artikel.ingress)
            ])
        })])
    }
}


//Testar en kompinent till och routing
let Nyheter = {
    view: () => {
        return (
            <div>
                <m.route.Link href="/nyheter">Nyheter</m.route.Link> <m.route.Link href="/artiklar">Artiklar</m.route.Link>

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



//Ladda nytt när man scrollat en bit ner.
//För att minimera att flera sidor laddas in innan nya har hämtats så switchar vi på "loadblock". Blocket tas bort efter uppdaterad view...
window.onscroll = () => {
    if (!loadblock) {
        let { top, height } = document.body.getBoundingClientRect()
        if (top + height <= 8000) {
            loadblock = true
            laddaArtiklar(Laddtyp.incremental)
            console.log("scroll")
        }
    }
}

//Inledande laddning av artiklar
laddaArtiklar(Laddtyp.reload)





