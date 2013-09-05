command! GolangTestCurrentPackage :call GolangTestCurrentPackage()
command! GolangTestFocused :call GolangTestFocused()

function! GolangUsingExamples()
  let examples_import_line_number = search("github.com\/lionelbarrow\/examples", "bs")
  if examples_import_line_number
    ''
  endif

  return examples_import_line_number
endfunction

function! GolangCurrentPackage()
  return "."
endfunction

function! GolangTestCurrentPackage()
  call VimuxRunCommand("clear; go test -v " . GolangCurrentPackage())
endfunction

function! GolangTestFocused()
  if GolangUsingExamples()
    return GolangTestFocusedExample()
  endif

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

function! GolangTestFocusedExample()
  let test_line = search("It(", "bs")
  ''

  if test_line > 0
    let line = getline(test_line)
    let raw_test_description = substitute(matchstr(line, 'It(".*"'), 'It(', '', '')
    let test_name = substitute(raw_test_description, '"', '', 'g')

    call VimuxRunCommand("clear; go test -examples.run '" . test_name . "' -v " . GolangCurrentPackage())
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
