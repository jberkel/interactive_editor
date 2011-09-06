# Interactive editor

Drew Neil has made it the subject of one of his vimcasts:
[vimcasts #20: running Vim within IRB][], and Chad Perrin has written an
article about it on TechRepublic:
[Use interactive_editor with irb for an inside-out Ruby IDE][].
There's also an outdated blog post which predates the gem from 2009:
[Integrating vim and IRB][].

## Usage

    $ gem install interactive_editor

Put the following in your .irbrc:

    require 'rubygems'
    require 'interactive_editor'

Then, from within irb:

    $ irb                        # or ripl
    > vi                         # (use vi w/ temp file)
    > vi 'filename.rb'           # (open filename.rb in vi)
    > ed                         # (use EDITOR env variable)
    > [emacs|vim|mvim|nano|mate] # (other editors)

Bonus: editing of objects on the fly (inspired by _why's [object aorta][])

    $ irb
    > { 'chunky' => 'bacon' }.vi

To try it out without installing the gem:

    $ git clone git://github.com/jberkel/interactive_editor.git
    $ cd interactive_editor
    $ rake console

interactive_editor also works with the IRB alternatives [ripl][] and [pry][].

## Credits

Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East
presentation: [Use vi or any text editor from within
IRB](http://gilesbowkett.blogspot.com/2007/10/use-vi-or-any-text-editor-from-within.html).

With contributions from:

  * [Renaud Morvan](https://github.com/nel)
  * [Jan Lelis](https://github.com/janlelis)
  * [TJ Singleton](https://github.com/tjsingleton)

[Integrating vim and irb]: http://zegoggl.es/2009/04/integrating-vim-and-irb.html
[vimcasts #20: Running Vim within IRB]: http://vimcasts.org/e/20
[Use interactive_editor with irb for an inside-out Ruby IDE]: http://www.techrepublic.com/blog/programming-and-development/use-interactiveeditor-with-irb-for-an-inside-out-ruby-ide/4125
[ripl]: https://github.com/cldwalker/ripl
[pry]: https://github.com/pry/pry
[object aorta]: http://rubyforge.org/snippet/detail.php?type=snippet&id=22
