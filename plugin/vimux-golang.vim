command! GolangTestCurrentPackage :call GolangTestCurrentPackage()
command! GolangTestFocused :call GolangTestFocused()

function! GolangCurrentPackage()
  let packageLine = search("package", "s")
  ''

  let packageName = split(getline(packageLine), " ")[1]
  let packagePath = [packageName]

  for i in split(bufname("%"), "/")[1:]
    if i == packageName
      break
    else
      call insert(packagePath, i)
    endif
  endfor

  return join(packagePath, "/")
endfunction

function! GolangTestCurrentPackage()
  call VimuxRunCommand("clear; go test -v " . GolangCurrentPackage())
endfunction

function! GolangTestFocused()
  let test_line = search("func Test", "bs")
  ''

  if test_line > 0
    let line = getline(test_line)
    let test_name_raw = split(line, " ")[1]
    let test_name = split(test_name_raw, "(")[0]

    call VimuxRunCommand("clear; go test -run '" . test_name . "$' -v " . GolangCurrentPackage())
  else
    echo "No test found"
  endif
endfunction

function! GolangRunOnChange()
  if executable("inotifywait")
    call VimuxRunCommand("while true; do inotifywait -q ".bufname("%")."; clear; go run play.go; done")
  else
    echo "You must have inotify-tools installed"
  endif
endfunction
