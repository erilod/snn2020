
type 
    State* [T] = ref object
        value*: seq[T]
        name*: cstring

proc `[]=`* [T](st:State[T], idx: int, val: T) =
    try: st.value[idx] = val
    except:
        for i in st.value.len .. idx:
            if i == idx:
                st.value.add(val)
            else:
                when val is SomeNumber:
                    st.value.add(0)
                when val is string:
                    st.value.add("")
                when val is object:
                    st.value.add(object)

method `[]`* [T](st:State[T], idx: int): T =
    try: return st.value[idx]
    except: discard


proc initState*(typ:typedesc, name: cstring = "state"): State[typ] =
    result = State[typ]()
    result.name = name
