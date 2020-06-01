Gem::Specification.new do |s|
  s.name = 'food52-cli'
  s.version = '1.0.0'
  s.authors = ['Rohan Likhite']
  s.email = 'contact@rohanlikhite.com'
  s.date = '2020-05-28'
  s.license = 'MIT'
  s.description = 'A terminal app that helps you find the perfect recipe for
    tonights meal by searching for keywords. View recipe ingredients and
    cooking instructions right from the command line!'
  s.summary = 'Search and view recipes through the command line'
  s.files = Dir['lib/*.rb', 'bin/*.rb']
  s.executables = ['food52-cli.rb']
  s.homepage = 'https://github.com/imRohan/food52-cli'
end
