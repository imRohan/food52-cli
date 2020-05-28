#!usr/bin/env ruby

# External Deps
require 'tty-prompt'

# External Files
require_relative 'cookbook'
include Cookbook

prompt = TTY::Prompt.new

name = prompt.ask('What would you like to eat today?')
recipes = Cookbook.search(name)

recipe_link = prompt.select("Heres what I found, which one would you like to read?", recipes)
recipe = Cookbook.get(recipe_link)

puts "Ok, here is the recipe"

puts "---Ingredents---"
recipe[:ingredients].each do | ingredient |
  puts ingredient
end

puts "---Steps---"
recipe[:steps].each do | step |
  puts step
end
