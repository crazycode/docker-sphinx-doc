# General

Dockerfile with:
* Sphinx documentation tool
* LaTeX
* HTML themes from http://docs.writethedocs.org/tools/sphinx-themes


## 中文支持

### 中文字体

修改sphinx工程的conf.py，加入以下内容：

```
latex_elements = {
...
# Additional stuff for the LaTeX preamble.
'preamble': '''
\usepackage{xeCJK}
\setCJKmainfont{WenQuanYi Zen Hei Sharp}
\setCJKmonofont[Scale=0.9]{WenQuanYi Zen Hei Mono}
\setCJKfamilyfont{song}{WenQuanYi Zen Hei}
\setCJKfamilyfont{sf}{WenQuanYi Zen Hei}
''',
}
```

字体根据个人喜好可以随意更改，要查询Linux下可用的中文字体，用以下命令：

    fc-list :lang=zh

### 中文首行缩进

仍然是更改latex_elements的preamble，加入一下内容：

```
\usepackage{indentfirst}
\setlength{\parindent}{2em}
```

这样每个段落的首行会缩进两个字符。

最终的conf.py中的preamble配置：

```
latex_elements = {
...
# Additional stuff for the LaTeX preamble.
'preamble': '''
\usepackage{xeCJK}
\usepackage{indentfirst}
\setlength{\parindent}{2em}
\setCJKmainfont{WenQuanYi Zen Hei Sharp}
\setCJKmonofont[Scale=0.9]{WenQuanYi Zen Hei Mono}
\setCJKfamilyfont{song}{WenQuanYi Zen Hei}
\setCJKfamilyfont{sf}{WenQuanYi Zen Hei}
''',
}
```

### 修改Sphinx

参考： http://seisman.info/chinese-support-for-sphinx.html

加入了xeCJK相关设置之后编译还是会出现问题:

```
! Undefined control sequence.
\GenericError  ...
            #4  \errhelp \@err@     ...
l.2856   }
```

这是由于xeCJK包与inputenc包发生冲突导致的，因而也需要修改。

首先在conf.py中设置language=zh_CN，然后修改/usr/local/lib/python2.7/dist-packages/sphinx/writers/latex.py，在231行左右加入语句对中文做特殊处理：

```
        if builder.config.language == 'zh_CN':
            self.elements['babel'] = ''
            self.elements['inputenc'] = ''
            self.elements['utf8extra'] = ''
```

第一个语句禁用了babel包，因而其尚不支持中文；第一个语句禁用了inputenc包，其与xeCJK冲突；第三个语句禁用了一个语句，该语句调用了inputenc包中的命令。

理论上完全可以通过修改conf.py中的latex_elements来禁用各种宏包的。但是实际上sphinx并没有提供禁用utf8extra的参数，即便禁用了inputenc依然是有问题的。

修改了这些之后，中文应该就没有问题了。在make latexpdf之前注意先make clean就好。

## Build image

```
$ docker build -t sphinx-doc .
```

## Run

Mounts a host directory (`/host-dir-with-sphinx-doc`) as a container volume (`/doc`).

```
$ docker run  -v /Users/yourname/docker/sphinx-doc/samples:/doc -i -t ubuntu/texlive:sphinx-zh /bin/bash
```

```
$ cd /doc
```

To create a pdf:
```
$ make latexpdf
```

得到需要的 .tex 文件，如 mybook.tex，进入其中的 build/latex 目录中，执行两次下面的命令：
```
$ xelatex mybook.tex
```

注意是执行两次，只执行一次的话会出现目录不能显示的问题。

例子 samples/how-to-write-makefile 是可以正常生成的。

To create a html document:
```
$ make html
```
