
# Interactive editor

cf. my blog post: [Integrating vim and irb](http://zegoggl.es/2009/04/integrating-vim-and-irb.html).

## Usage

    $ gem install interactive_editor

Put the following in your .irbrc:

    require 'rubygems'
    require 'interactive_editor'

Then, from within irb:

    $ irb
    > vi
    > vi 'filename.rb'
    > [emacs|vim|nano|mate] ...

To try it out without installing the gem:

    $ git clone git://github.com/jberkel/interactive_editor.git
    $ cd interactive_editor
    $ rake console

## Credits

Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation: [Use vi or any text editor from within IRB](http://gilesbowkett.blogspot.com/2007/10/use-vi-or-any-text-editor-from-within.html).
