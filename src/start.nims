import os, strutils, strformat

## Ett skript som körs vid komp och bakar ihop alla css filer under komponenter till en css

var comptext: string 

proc readCats (dir:string) =
    for filename in listFiles(dir):
        var filesplit = splitFile(filename)
        if filesplit.ext == ".css":
            comptext.add &"""
/* importerad: {filename}  */ 
{readFile(filename)}

"""
            
    for recDir in listDirs(dir):
        readCats(recDir)

readCats("src")
writeFile("styles.css", comptext)
