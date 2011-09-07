Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'interactive_editor'
  s.version           = '0.0.10'
  s.date              = '2011-09-07'
  s.rubyforge_project = 'interactive_editor'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "Interactive editing in irb."
  s.description = "Use vim (or any other text editor) from inside irb to quickly test & write new code."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Jan Berkel"]
  s.email    = 'jan.berkel@gmail.com'
  s.homepage = 'http://github.com/jberkel/interactive_editor'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency('spoon', [">= 0.0.1"])

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.md
    Rakefile
    interactive_editor.gemspec
    lib/interactive_editor.rb
  ]
  # = MANIFEST =

  s.license = 'MIT'

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
