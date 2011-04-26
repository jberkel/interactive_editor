require 'rubygems'
require 'rake'
require 'date'

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

task :default => :test

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end



#############################################################################
#
# Packaging tasks
#
#############################################################################

desc "release the gem"
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master --tags"
  sh "gem push pkg/#{name}-#{version}.gem"
end

desc "Builds the gem"
task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

task :gemspec => :validate do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)
  #comment this out if your rubyforge_project has a different name
  replace_header(head, :rubyforge_project)

  # determine file list from git ls-files
  files = `git ls-files`.
    split("\n").
    sort.
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg)/ }.
    map { |file| "    #{file}" }.
    join("\n")

  # piece file back together and write
  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
  File.open(gemspec_file, 'w') { |io| io.write(spec) }
  puts "Updated #{gemspec_file}"
end

task :validate do
  libfiles = Dir['lib/*'] - ["lib/#{name}.rb"]
  unless libfiles.empty?
    puts "Directory `lib` should only contain a `#{name}.rb` file and `#{name}` dir."
    exit!
  end
  unless Dir['VERSION*'].empty?
    puts "A `VERSION` file at root level violates Gem best practices."
    exit!
  end
end

namespace :doc do
  desc "Render markdown as if it were shown on github, expects FILE=path/to/doc.md"
  task :preview do
    infile = File.expand_path(ENV['FILE'].to_s)
    outfile = "/tmp/#{File.basename(infile)}.html"
    revision = `git rev-parse HEAD`.strip
    markdown = `which markdown`.strip

    unless $?.success?
      puts "Make sure you have 'markdown' in your path, usage: brew install markdown"
      exit 1
    end

    unless File.exists?(infile)
      puts "Cannot find FILE=#{ENV['FILE'].inspect}, usage: rake soundcloud:doc:preview FILE=doc/hello.md"
      exit 2
    end

    File.open(outfile, "w") do |out|
      body = `#{markdown} #{infile}`
      template = <<-END
        <html>
          <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
          <meta http-equiv="X-UA-Compatible" content="chrome=1">
          <head>
            <link href="https://assets0.github.com/stylesheets/bundle_common.css?#{revision}" media="screen" rel="stylesheet" type="text/css" />
            <link href="https://assets3.github.com/stylesheets/bundle_github.css?#{revision}" media="screen" rel="stylesheet" type="text/css" />
          </head>
          <body>
            <div id="readme" class="blob">
              <div class="wikistyle">
                #{body}
              </div>
            </div>
          </body>
        </html>
      END
      out.write(template)
    end

    puts "Launching: open #{outfile}"
    system("open #{outfile}")
  end
end
