command! GolangTestCurrentPackage :call GolangTestCurrentPackage()

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
  call VimuxRunCommand("clear;go test " . GolangCurrentPackage())
endfunction
