include karax/prelude
import dom, jsconsole, asyncjs

type 
    Artikel* = ref object
        title* : kstring
        id* : cint
        rubrik* : kstring
        urlTitle* : kstring
        status* : kstring
        date* : cint
        channel* : kstring
        ingress* : kstring
        ettabild* : kstring
        edit_date* : cint

    Artiklar* = seq[Artikel]

var 
    artiklar* : Artiklar = @[Artikel(title: "Default")]
    loadBlock = false
    getUrl* {.importc: "window.location.pathname".} : cstring

proc pushUrl* (url:cstring) {.importjs: "window.history.pushState([],'state',#)" .} =
    redraw()
    
# Egen generisk ffi-funktion (import jsonToType) som castar json-sträng till vald typ
proc parseJson* (str: cstring, typ: typedesc): typ {. importjs: "JSON.parse(#)" .}

proc stringifyJson* [T] (obj: T): cstring {. importjs: "JSON.stringify(#)" .}

type
    Request = ref object
        onreadystatechange: proc () 
        responseText: cstring
        readyState: cint
        status: cint

proc open(req: Request, met: cstring, url: cstring, async: bool) {.importjs: "#.open(#,#,#)".}
proc send(req: Request) {. importjs: "#.send()" .}
proc newReq (): Request {.importjs: "new XMLHttpRequest()" .}

proc loadDataObject(url: string, typ: typedesc): Future[typ] =
    var req = newReq()
    req.open("GET", url, true)
    result = newPromise(proc (resolve: proc (data:typ)) =
        req.onreadystatechange = proc () =
            if req.readyState == 4 and req.status == 200:
                resolve(parseJson(req.responseText, Artiklar))
    )
    req.send()

proc loadData (url:string): Future[cstring] =
    var req = newReq()
    req.open("GET", url, true)
    result = newPromise(proc (resolve: proc (data:cstring)) =
        req.onreadystatechange = proc () =
            if req.readyState == 4 and req.status == 200:
                resolve(req.responseText)
    )
    req.send()

proc getItem (key: cstring): cstring {. importjs: "window.localStorage.getItem(#)" .}
proc setItem (key: cstring, val: cstring) {. importjs: "window.localStorage.setItem(@)" .}


# Första koll om det finns artiklar i localStorage, ladda!
proc preload* () {.async.} =
    let local = getItem("artiklar")
    if not local.isNil:
        artiklar = local.parseJson(Artiklar)
        echo "Preloaded"



# Den andra rundan, laddar in senaste från servern
proc ladda* () {.async.} =
    let p1 = await loadData("https://www.sydnarkenytt.se/json/etta/P1")
    setItem("artiklar", p1)
    artiklar = p1.parseJson(Artiklar)
    echo "Reloaded"

# Ladda vid scroll
proc laddaScroll* () {.async.} =
        let px = await loadData("https://www.sydnarkenytt.se/json/etta/P" & $artiklar.len)
        artiklar.add(px.parseJson(Artiklar))
        loadBlock = false

window.addEventListener("scroll", proc (e: Event) =
    if not loadblock:
        let top = document.body.getBoundingClientRect().top
        let height = document.body.getBoundingClientRect().height
        if (top + height <= 8000):
            discard laddaScroll()
            echo "scrolload"
            loadBlock = true
)
