" return full path with the trailing slash
"  or an empty string if we're not in an npm project
fun! s:GetNodeModulesAbsPath ()
  let lcd_saved = fnameescape(getcwd())
  silent! exec "lcd" expand('%:p:h')
  let path = finddir('node_modules', '.;')
  exec "lcd" lcd_saved

  " fnamemodify will return full path with trailing slash;
  " if no node_modules found, we're safe
  return path is '' ? '' : fnamemodify(path, ':p')
endfun

" return full path of local stylelint executable
"  or an empty string if no executable found
fun! s:GetStylelintExec (node_modules)
  let stylelint_guess = a:node_modules is '' ? '' : a:node_modules . '.bin/stylelint'
  return exepath(stylelint_guess)
endfun

" if stylelint_exec found successfully, set it for the current buffer
fun! s:LetStylelintExec (stylelint_exec)
  if a:stylelint_exec isnot ''
    let b:syntastic_css_stylelint_exec = a:stylelint_exec
  endif
endfun

fun! s:main ()
  let node_modules = s:GetNodeModulesAbsPath()
  let stylelint_exec = s:GetStylelintExec(node_modules)
  call s:LetStylelintExec(stylelint_exec)
endfun

call s:main()
