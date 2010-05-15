# vim: set syntax=ruby :
# Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation.
# http://gilesbowkett.blogspot.com/2007/10/use-vi-or-any-text-editor-from-within.html

require 'irb'
require 'fileutils'
require 'tempfile'

class InteractiveEditor
  VERSION = '0.0.1'

  attr_accessor :editor

  def initialize(editor)
    @editor = editor.to_s
  end

  def edit(file=nil)
    @file = if file
       FileUtils.touch(file) unless File.exist?(file)
       File.new(file)
      else
       (@file && File.exist?(@file.path)) ? @file : Tempfile.new(["irb_tempfile", ".rb"])
    end
    mtime = File.stat(@file.path).mtime
    Exec.system(@editor, @file.path)

    execute if mtime < File.stat(@file.path).mtime
  end

  def execute
    Object.class_eval(IO.read(@file.path))
  end

  def self.edit(editor, file=nil)
    #idea serialise last file to disk, for recovery
    unless IRB.conf[:interactive_editors] && IRB.conf[:interactive_editors][editor]
      IRB.conf[:interactive_editors] ||= {}
      IRB.conf[:interactive_editors][editor] = InteractiveEditor.new(editor)
    end
    IRB.conf[:interactive_editors][editor].edit(file)
  end

  module Exec
    extend self

    if RUBY_PLATFORM =~ /java/
      #http://github.com/headius/spoon
      require 'rubygems'
      require 'spoon'

      def system(*args)
        Process.waitpid(Spoon.spawnp(*args))
      end
    else
      def system(file, *args)
        Kernel::system(file, *args)
      end
    end
  end

  module Editors
    {
      :vi    => nil,
      :vim   => nil,
      :emacs => nil,
      :nano  => nil,
      :mate  => 'mate -w'
    }.each do |k,v|
      define_method(k) do |*args|
       InteractiveEditor.edit(v || k, *args)
      end
    end
  end
end

Object.send(:include, InteractiveEditor::Editors)

