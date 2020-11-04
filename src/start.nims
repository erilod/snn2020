import os, strutils

## Ett skript som körs vid kompilering och bakar ihop alla css filer under komponenter till en under webroot
var comptext: seq[string]
var endtext: string

for dir in listDirs("src/komponenter"):
    for filename in listFiles(dir):
        echo "readfile"
        var filesplit = splitFile(filename)
        if filesplit.ext == ".css":
            comptext.add("\n\n /* importerad: " & filename & "*/ \n" & readFile(filename) )

for filename in listFiles("src"):
    echo "readfile"
    var filesplit = splitFile(filename)
    if filesplit.ext == ".css":
        comptext.add("\n\n /* importerad: " & filename & "*/ \n" & readFile(filename) )

for filename in listFiles("src/komponenter"):
    echo "readfile"
    var filesplit = splitFile(filename)
    if filesplit.ext == ".css":
        comptext.add("\n\n /* importerad: " & filename & "*/ \n" & readFile(filename) )


for part in comptext:
    echo "Skriver"
    endtext.add(part)
    writefile("docs/styles.css", endtext)