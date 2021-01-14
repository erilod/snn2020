import tables

type 
    DataState* = ref object of RootObj
        titel*: cstring
        ingress*: cstring
        id*: cint
        sida* : Table[string, Infosida]

    Artikeldata* = ref object of DataState
        ettapuff*: cstring

    Infosida* = ref object of DataState
        stycken: seq[Stycke]
    
    Stycke* = ref object of DataState
        rubrik: string
        bild: string
        text: string

let model* = Artikeldata(titel: "Från global state", sida: {"minsida": Infosida(stycken: @[Stycke(rubrik:"Min styckerubrik")])}.toTable)
