type 
    DataState* = ref object of RootObj
        titel*: cstring
        ingress*: cstring
        id*: cint

    Artikeldata* = ref object of DataState
        ettapuff*: cstring