include karax/prelude
import dom, jsconsole, asyncjs, strutils

type
    Artikel* = ref object of RootObj
        title* : kstring
        id* : cint
        rubrik* : kstring
        urlTitle* : kstring
        ort*: kstring
        status* : kstring
        date* : cint
        channel* : kstring
        ingress* : kstring
        ettabild* : kstring
        edit_date* : cint

    Segments* = seq[cstring]

    Artiklar* = seq[Artikel]

    # för ajax
    Request = ref object
        onreadystatechange: proc () 
        responseText: cstring
        readyState: cint
        status: cint

var 
    artiklar* : Artiklar = @[Artikel(title: "Default")]
    artiklarKumla* : Artiklar = @[Artikel(title: "Default")]
    loadBlock = false # blockerar inladdning av nya artiklar vid scroll innan de föregående är inlästa

# Json wrapper
proc parseJson* (str: cstring, typ: typedesc): typ {. importjs: "JSON.parse(#)" .}
proc stringifyJson* [T] (obj: T): cstring {. importjs: "JSON.stringify(#)" .}

# Ajax
proc open(req: Request, met: cstring, url: cstring, async: bool) {.importjs: "#.open(#,#,#)".}
proc send(req: Request) {. importjs: "#.send()" .}
proc newReq (): Request {.importjs: "new XMLHttpRequest()" .}

proc loadDataObject(url: string, typ: typedesc): Future[typ] =
    ##Laddar frpn url och p arsar till vald objekt-typ 
    var req = newReq()
    req.open("GET", url, true)
    result = newPromise(proc (resolve: proc (data:typ)) =
        req.onreadystatechange = proc () =
            if req.readyState == 4 and req.status == 200:
                resolve(parseJson(req.responseText, Artiklar))
    )
    req.send()

proc loadData (url:string): Future[cstring] =
    # Laddar frpn url och p arsar till vald objekt-typ 
    var req = newReq()
    req.open("GET", url, true)
    result = newPromise(proc (resolve: proc (data:cstring)) =
        req.onreadystatechange = proc () =
            if req.readyState == 4 and req.status == 200:
                resolve(req.responseText)
    )
    req.send()

# Local storage
proc getItem (key: cstring): cstring {. importjs: "window.localStorage.getItem(#)" .}
proc setItem (key: cstring, val: cstring) {. importjs: "window.localStorage.setItem(@)" .}

# Routing
var 
    pathname* {.importc: "window.location.pathname".} : cstring
    hashname* {.importc: "window.location.hash".} : cstring

proc pullUrl* (): Segments =
    return pathname.split("/")

proc replaceUrl* (url:cstring) {.importjs: "window.history.replaceState([],'state',#)" .}
    # todo: ändra "state" till något vettigt.
    

### Ladda artiklar

proc preladda* () {.async.} =
    ## Första koll om det finns artiklar i localStorage, ladda!
    let local = getItem("artiklar")
    if not local.isNil:
        artiklar = local.parseJson(Artiklar)
        echo "Preloaded"
    redraw()

proc ladda* () {.async.} =
    ## Den andra rundan, laddar in senaste från servern
    let p1 = await loadData("https://www.sydnarkenytt.se/json/etta/P1")
    setItem("artiklar", p1)
    artiklar = p1.parseJson(Artiklar)
    redraw()

### Ladda vid scroll
proc laddaScroll* () {.async.} =
        let px = await loadData("https://www.sydnarkenytt.se/json/etta/P" & $artiklar.len)
        artiklar.add(px.parseJson(Artiklar))
        redraw()
        if pathname == "/kumla": echo "ok" else: echo "not"
        loadBlock = false

### Events

window.addEventListener("scroll") do(e: Event):
    ## Vid scroll på sidan lada nytt.
    # Todo: Endast vid nyhetssidan och inte globalt?
    if not loadblock:
        let top = document.body.getBoundingClientRect().top
        let height = document.body.getBoundingClientRect().height
        if (top + height <= 8000):
            discard laddaScroll()
            echo "scrolload"
            loadBlock = true

window.addEventListener("click", proc(ev: Event) =
    ev.preventDefault()
    let href = ev.target.getAttribute("href")
    replaceUrl(href)
)

