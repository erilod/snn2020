import ../../moduler/ [ladda]
include karax / prelude
import dom, jsconsole, asyncjs, strutils
import ../../moduler/ states

var state = initState(int, "minstate")

proc raknare* (idx:int = 0): VNode =
    result = buildHtml(tdiv(id = "id_" & $idx)):
        p: text $state[idx]
        textarea(value = $state[idx]):
            proc onkeyup (ev:Event, nd:VNode) =
                state[idx] = parseInt(nd.value)
                console.log(state)
        button:
            text "Öka"
            proc onclick (ev:Event, nd:VNode) =
                state[idx] = state[idx]+1
                console.log(state)
                redraw()
        button:
            text "Minska"
            proc onclick (ev:Event, nd:VNode) =
                state[idx] = state[idx]-1
                console.log(state)
                redraw()

