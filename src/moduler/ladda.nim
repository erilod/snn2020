include karax/prelude
import dom, jsconsole, asyncjs


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

    Artiklar* = seq[Artikel]

    # för ajax
    Request = ref object
        onreadystatechange: proc () 
        responseText: cstring
        readyState: cint
        status: cint

var 
    artiklar* : Artiklar = @[Artikel(title: "Default")]
    loadBlock = false # blockerar inladdning av nya artiklar vid scroll innan de föregående är inlästa

# Generiska ffi som castar json till vald typ samt stringify obj till json.
proc parseJson* (str: cstring, typ: typedesc): typ {. importjs: "JSON.parse(#)" .}
proc stringifyJson* [T] (obj: T): cstring {. importjs: "JSON.stringify(#)" .}

# Js ffi för ajax
proc open(req: Request, met: cstring, url: cstring, async: bool) {.importjs: "#.open(#,#,#)".}
proc send(req: Request) {. importjs: "#.send()" .}
proc newReq (): Request {.importjs: "new XMLHttpRequest()" .}

# Två funktioner för ajax. En parsar till vald objekt-typ det andra en json
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


## Laddar artiklar. Exporterade.
## 
# Första koll om det finns artiklar i localStorage, ladda!
proc preladda* () {.async.} =
    let local = getItem("artiklar")
    if not local.isNil:
        artiklar = local.parseJson(Artiklar)
        echo "Preloaded"
    redraw()

# Den andra rundan, laddar in senaste från servern
proc ladda* () {.async.} =
    let p1 = await loadData("https://www.sydnarkenytt.se/json/etta/P1")
    setItem("artiklar", p1)
    artiklar = p1.parseJson(Artiklar)
    echo "Reloaded"
    redraw()

# Ladda vid scroll
proc laddaScroll* () {.async.} =
        let px = await loadData("https://www.sydnarkenytt.se/json/etta/P" & $artiklar.len)
        artiklar.add(px.parseJson(Artiklar))
        redraw()
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
