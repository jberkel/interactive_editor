# vim: set syntax=ruby :
# Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation.
# http://gilesbowkett.blogspot.com/2007/10/use-vi-or-any-text-editor-from-within.html

require 'irb'
require 'fileutils'
require 'tempfile'
require 'shellwords'

class InteractiveEditor
  VERSION = '0.0.6'

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

    args = Shellwords.shellwords(@editor) #parse @editor as arguments could be complex
    args << @file.path
    Exec.system(*args) 

    execute if mtime < File.stat(@file.path).mtime
  end

  def execute
    eval(IO.read(@file.path), TOPLEVEL_BINDING)
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
        Kernel::system(file, *args) #or raise "error exec'ing #{file}: #{$?}"
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
      :mate  => 'mate -w',
      :mvim  => 'mvim -g -f' + case ENV['TERM_PROGRAM']
        when 'iTerm.app' then ' -c "au VimLeave * !open -a iTerm"' #on close refocus on iTerm
        when 'Apple_Terminal' then ' -c "au VimLeave * !open -a Terminal"' #on close refocus on Terminal
        else '' #don't do tricky things if we don't know the Term
      end
    }.each do |k,v|
      define_method(k) do |*args|
       InteractiveEditor.edit(v || k, *args)
      end
    end

    def ed(*args)
      if ENV['EDITOR'].to_s.size > 0
        InteractiveEditor.edit(ENV['EDITOR'], *args)
      else
        raise "You need to set the EDITOR environment variable first"
      end
    end
  end
end

include InteractiveEditor::Editors
