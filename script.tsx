import m from "mithril"
import * as Mithril from "mithril"

// Fyller på med artiklar här
let artiklar = []
let loadblock: boolean

// När man vill ladda flera artiklar. Utgår fån längden och laddar
function laddaArtiklar() {
    let paginate = artiklar.length
    let url = "https://www.sydnarkenytt.se/json/etta/P" + paginate

    m.request({
        url: url
    }).then(resp => {
        artiklar = artiklar.concat(resp)
    })
}

//Två varianter med och utan JSX
// JSX med två komponenter En för varje artikelpuff som tar in data via attrs. En som renderar hela listan.  
// Föredrar ren js och inte jsx då det blir flera abstraktionsnivåer. Renare kod.

let Artikel = {
    view: (vnode)=>{
        return (
        <div>
            {vnode.attrs.src ? (<img width="100px" src={vnode.attrs.src}/>) : (<img alt="Ingen bild"/>)}
            <h1>{vnode.attrs.title}</h1>
            <p>{vnode.attrs.ingress}</p>
        </div>)
    }
}

let Artiklar = {
    onupdate: () => {
        loadblock = false
    },
    view: () => {
        return (
            <div>
                {artiklar.map(artikel=>{
                    return (
                        <Artikel title={artikel.title} ingress={artikel.ingress} src={artikel.ettabild}/>
                    )
                })}
            </div>
        )
    }
}

// Motsvarande i  js förutom att den inte är uppdelad i två komponenter
//En Mithril komponent. Kan också använda JSX. Kan skapa utifrån klasser vid större projekt.
// Data direkt från globala artiklar
let Sidan = {
    view: () => {
        return m("div", [artiklar.map(artikel => {
            return m("div", [
                artikel.ettabild ? m("img", {style: {width: "100px"}, src: "https:" + artikel.ettabild}) : m("") ,
                m("h1", artikel.title),
                m("p", artikel.ingress)
            ])
        })])
    }
}

//Ladda nytt när man scrollat en bit ner.
//För att minimera att flera sidor laddas in innan nya har hämtats så switchar vi på "loadblock". Blocket tas bort efter uppdaterad view...
loadblock = false
window.onscroll = () => {
    if (!loadblock) {
        let { top, height } = document.body.getBoundingClientRect()
        if (top + height <= 8000) {
            loadblock = true
            laddaArtiklar()
        }
    }
}

laddaArtiklar()
Mithril.mount(document.body, Artiklar)
