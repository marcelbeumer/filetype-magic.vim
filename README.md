filetype-magic.vim
==================

My (hacky) filetype magic in vim. Makes builtin ``gf`` smarter and adds parsing source lines before feeding it to ``gf``. Hardcoded to serve my specific project needs, dumped in a plugin not to clutter my vimrc.

- Install the plugin using vundle ```Bundle 'marcelbeumer/filetype-magic.vim'``` (or use anything else).
- Map something like ```map  <leader>g :call EditIncludeOnLine()<CR>```

Examples
--------

Doing ```<leader>g``` on
```
<div class="homepage__wrap__signupBox">
```
Will jump to ```homepage.less```

Doing ```<leader>g``` on
```
use Symfony\Component\HttpKernel\Exception\HttpException;
```
Will jump to ```Symfony/Component/HttpKernel/Exception/HttpException.php```

Doing ```<leader>g``` on
```
{% extends 'InterNationsLayoutBundle:Responsive:layout.html.twig' %}
```
Will jump to ```LayoutBundle/Resources/views/Responsive/layout.html.twig```
