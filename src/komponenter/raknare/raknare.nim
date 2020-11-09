import ../../moduler/ [ladda]
include karax / prelude
import dom, jsconsole, asyncjs, strutils, tables


type 
    State [T] = ref object
        val: seq[T]
        name: cstring

proc add[T](st:State[T], idx: int, val: T) =
    try: discard st.val[idx]
    except: st.val.add(val)

method get[T](st:State[T], idx: int): T =
    try: return st.val[idx]
    except: discard

proc set[T](st:State[T], idx: int, val: T) =
    try: st.val[idx] = val
    except: st.val.add(val)

proc initState(tp:typedesc, name: cstring = "state"): State[tp] =
    result = State[tp]()
    result.name = name

var state = initState(int, "minstate")

proc raknare* (idx:int = 0): VNode =
    state.add(idx, 333)
    result = buildHtml(tdiv(id = "id_" & $idx)):
        p: text $state.get(idx)
        textarea(value = $state.get(idx)):
            proc onkeyup (ev:Event, nd:VNode) =
                state.set(idx, parseInt(nd.value))
                console.log(state)
        button:
            text "Öka"
            proc onclick (ev:Event, nd:VNode) =
                state.set(idx, state.get(idx)+1)
                console.log(state)
                redraw()
        button:
            text "Minska"
            proc onclick (ev:Event, nd:VNode) =
                state.set(idx, state.get(idx)-1)
