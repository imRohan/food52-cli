#!usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH << File.join(File.dirname(__FILE__), '/../lib')
require 'chef'

begin
  Chef.init
rescue SystemExit, Interrupt
  puts
  puts 'Bon Appetit!'
  puts
end
