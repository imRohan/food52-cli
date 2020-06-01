#!usr/bin/env ruby
# frozen_string_literal: true

$: << File.join(File.dirname(__FILE__), "/../lib")
require 'chef'


begin
  Chef.ask
rescue SystemExit, Interrupt => e
  puts
  puts 'Bon Appetit!'
  puts
end


