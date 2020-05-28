Gem::Specification.new do |s|  
  s.name = 'food52-cli'
  s.version = '1.0.0'
  s.authors = ['Rohan Likhite']
  s.date = '2020-05-28'
  s.summary = 'Search and view recipes through the command line'
  s.files = Dir['lib/**/*.rb', 'bin/*.rb']
  s.require_paths = ['lib']
  s.executables = ['main.rb']
  s.homepage = 'https://github.com/imRohan/food52-cli'
end
