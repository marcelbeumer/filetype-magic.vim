" If already loaded, we're done...
if exists('g:loaded_filetype_magic')
  finish
endif
let g:loaded_filetype_magic = 1

function! EditIncludeOnLine()
    let line = getline('.')
    if exists("b:edit_include_line_parser")
        let GrabFn = function(b:edit_include_line_parser)
        let line = call(GrabFn, [line])
    endif
    let path = line
    if exists("b:edit_include_path_resolver")
        let ResolveFn = function(b:edit_include_path_resolver)
        let path = call(ResolveFn, [line])
    endif
    let path = findfile(path)
    exec 'e ' . path
endfunction

function! EditIncludeBufferSetup(pathResolver, lineParser)
    let lineParser = 'DefaultIncludeLineParser'
    if strlen(a:lineParser) > 0
        let lineParser = a:lineParser
    endif
    exec 'let b:edit_include_line_parser=''' . lineParser . ''''
    if strlen(a:pathResolver) > 0
        exec 'let b:edit_include_path_resolver=''' . a:pathResolver . ''''
        exec 'setlocal includeexpr=' . a:pathResolver . '(v:fname)'
    endif
endfunction

function! DefaultIncludeLineParser(line)
    return substitute(a:line, '.\{-}[''"]\(.\{-}\)[''"].*', '\1', 'g')
endfunction

function! PHPEditIncludeLineParser(line)
    let line = substitute(a:line, '.\{-}use\s\+\(\S*\);.*', '\1', 'g')
    return DefaultIncludeLineParser(line)
endfunction

function! SUITEditIncludeLineParser(line)
    " Find class="..." and break off _ and - so we match the component name
    let line = substitute(a:line, '.*class=".\{-}\(\w\{-}\)[_-].*', '"\1"', 'g')
    return DefaultIncludeLineParser(line)
endfunction

function! PHPEditIncludePathResolver(fname)
    let fname = a:fname
    if stridx(fname, ':') != -1
        let fname = TwigEditIncludePathResolver(fname)
    endif
    return substitute(fname, '\', '/', 'g')
endfunction

function! TwigEditIncludePathResolver(fname)
    let fname = a:fname
    " let fname = SUITEditIncludePathResolver(fname)
    let fname = substitute(fname, ':', '/', 'g')
    let fname = substitute(fname, '^InterNations\(.\{-}\)Bundle', '\1Bundle/Resources/views/', 'g')
    return fname
endfunction

function! PHPSettings()
    call EditIncludeBufferSetup('PHPEditIncludePathResolver', 'PHPEditIncludeLineParser')
    setlocal suffixesadd+=.php
    setlocal path+=app-new/src/**
    setlocal path+=vendor/sensio/**
    setlocal path+=vendor/twig/**
    setlocal path+=vendor/symfony/**
    setlocal path+=vendor/doctrine/**
endfunction

" Ideally
" function! PHPSettings()
"     let b:edit_include_line_parser='PHPIncludeLineParser'
"     setlocal includeexpr=PHPIncludeExpr(v:fname)
"     setlocal suffixesadd+=.php
"     setlocal path+=app-new/src/**
"     setlocal path+=vendor/sensio/**
"     setlocal path+=vendor/twig/**
"     setlocal path+=vendor/symfony/**
"     setlocal path+=vendor/doctrine/**
"  endfunction

function! HTMLTwigSettings()
    call EditIncludeBufferSetup('TwigEditIncludePathResolver', 'SUITEditIncludeLineParser')
    setlocal suffixesadd+=.less
    setlocal path+=app-new/src/**
endfunction

function! HTMLSettings()
    call EditIncludeBufferSetup('', 'SUITEditIncludeLineParser')
    setlocal suffixesadd+=.less
    setlocal path+=app-new/src/**
endfunction

function! XMLSettings()
    call EditIncludeBufferSetup('PHPEditIncludePathResolver', '')
    setlocal path+=app-new/src/**
endfunction

function! JavaScriptSettings()
    call EditIncludeBufferSetup('', '')
    setlocal suffixesadd+=.js
    setlocal path+=app-new/src/**
endfunction

autocmd FileType php call PHPSettings()
autocmd FileType javascript call JavaScriptSettings()
autocmd FileType html call HTMLSettings()
autocmd FileType html.twig call HTMLTwigSettings()
autocmd FileType xml call XMLSettings()
