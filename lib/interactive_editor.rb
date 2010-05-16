# vim: set syntax=ruby :
# Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation.
# http://gilesbowkett.blogspot.com/2007/10/use-vi-or-any-text-editor-from-within.html

require 'irb'
require 'fileutils'
require 'tempfile'

class InteractiveEditor
  VERSION = '0.0.2'

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

    if (args = @editor.split(/\s+/)).size > 1
      Exec.system(args[0], *(args[1..-1] << @file.path))
    else
      Exec.system(@editor, @file.path)
    end

    execute if mtime < File.stat(@file.path).mtime
  end

  def execute
    Object.class_eval(IO.read(@file.path))
  end

  def self.edit(editor, file=nil)
    #maybe serialise last file to disk, for recovery
    (IRB.conf[:interactive_editors] ||=
      Hash.new { |h,k| h[k] = InteractiveEditor.new(k) })[editor].edit(file)
  end

  module Exec
    module Java
      def system(file, *args)
        require 'spoon'
        Process.waitpid(Spoon.spawnp(file, *args))
      rescue Errno::ECHILD => e
        raise "error exec'ing #{file}: #{e}"
      end
    end

    module MRI
      def system(file, *args)
        Kernel::system(file, *args) or raise "error exec'ing #{file}: #{$?}"
      end
    end

    extend RUBY_PLATFORM =~ /java/ ? Java : MRI
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

include InteractiveEditor::Editors