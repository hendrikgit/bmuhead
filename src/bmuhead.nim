import os, sequtils, strformat

const
  bmuHeader = "BMU V1.0"
  fileExtensions = [".bmu", ".wav"]
  usage = &"""
(Version: {getEnv("VERSION")})
Provide one or more filenames as parameters.
The text "{bmuHeader}" will be added to the beginning of each file.
If the file already starts like that nothing will be done.
"""

if paramCount() == 0 or commandLineParams().anyIt it in ["-h", "--h", "-help", "--help"]:
  echo usage
  quit(QuitSuccess)

for fn in commandLineParams():
  stdout.write(fn & ": ")
  stdout.flushFile
  if not fn.fileExists:
    echo "file not found"
    continue
  if fn.splitFile.ext notin fileExtensions:
    echo "skipping because extension does not match " & $fileExtensions
    continue
  let srcFile = open(fn, fmRead)
  var fileHead = newString(bmuHeader.len)
  if srcFile.readChars(fileHead, 0, bmuHeader.len) == bmuHeader.len and fileHead == bmuHeader:
    echo &"\"{bmuHeader}\" header already present"
  else:
    srcFile.setFilePos(0)
    let outFn = ".temp-" & fn & ".bmuhead"
    let outFile = open(outFn, fmWrite)
    outFile.write(bmuHeader)
    var buffer: array[4096, byte]
    while true:
      let bytesRead = srcFile.readBytes(buffer, 0, buffer.len)
      if bytesRead == 0: break
      doAssert outFile.writeBytes(buffer, 0, bytesRead) == bytesRead, "Error writing to temporary file"
    outFile.close
    moveFile(outFn, fn)
    echo &"\"{bmuHeader}\" header added"
  srcFile.close
