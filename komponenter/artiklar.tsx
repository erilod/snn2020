import m from "mithril"
import * as Ladda from "../moduler/laddartiklar"
import * as Mithril from "mithril"
@import "./artiklar.css"


interface Artikel {
        title : string,
        id : number,
        rubrik : string,
        urlTitle : string,
        status : string,
        date : number,
        channel : string,
        ingress : string
}

let Artikel = {
    view: (vnode) => {
        if (vnode.attrs.status == "open") {
            return (
                <div class="artikel">
                    <h2 class="artikel-rubrik">{vnode.attrs.title}</h2>
                </div>
            )
        }
        return (
            <div class="artikel">
                {vnode.attrs.src ? (<img class="artikel-bild" src={"https:" + vnode.attrs.src} />) : null}
                <h1 class="artikel-rubrik">{(vnode.attrs.title.replace(/&quot;/g, '"'))}</h1>
                <p>{vnode.attrs.ingress}</p>
            </div>)
    }
}


export let Artiklar = {
    onbeforeuodate: () => {
        Ladda.ladda("reload")

    },
    onupdate: () => {
        //Innehållet renderat. Flagga att det är ok att ladda vid scroll
        Ladda.setLoadblock(false)

    },
    view: (vnode) => {
        console.log(Mithril.route.get())
        return (
            <div>
                <m.route.Link class={"button " + (Mithril.route.get() == "/nyheter" ? "active" : "inactive")} href="/nyheter">Nyheter</m.route.Link> <m.route.Link class={"button " + (Mithril.route.get() == "/artiklar"? "active" : "inactive")} href="/artiklar">Artiklar</m.route.Link>
                {Ladda.artiklar.map((artikel:Artikel) => {
                    return (
                        <Artikel status={artikel.status} title={artikel.title} key={artikel.id} ingress={artikel.ingress} src={artikel.ettabild} />
                    )
                })}
            </div>
        )
    }
}
