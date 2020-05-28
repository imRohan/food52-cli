# frozen_string_literal: true

# External Deps
require 'tty-prompt'
require 'terminal-table'
require 'word_wrap'

# External Files
require_relative 'cookbook'

# Presents the user with conversation style interface to find recipes
module Chef
  @prompt = TTY::Prompt.new

  def self.ask
    keywords = @prompt.ask('What would you like to eat today?')
    Chef.present(keywords)
  end

  def self.present(keywords)
    recipes = Cookbook.search(keywords)

    recipe_name = @prompt.select("Found #{recipes.length} recipes:", recipes.keys)
    recipe = Cookbook.get(recipes[recipe_name])

    description, ingredients, steps = recipe.values_at(:description, :ingredients, :steps)

    recipe_table = Terminal::Table.new do |table|
      table.title = recipe_name
      table.add_row [{ value: "Ingredients - #{ingredients.length} total", alignment: :center }]
      ingredients.each do |ingredient|
        table.add_row [ingredient]
      end
    end
    puts recipe_table

    puts "\n"
    puts 'Description'
    description_wraped = WordWrap.ww(description, 100)
    puts description_wraped

    puts "\n"
    puts 'Steps'
    steps.each.with_index(1) do |step, index|
      step_wraped = WordWrap.ww(step, 100)
      puts "#{index}) #{step_wraped} \n"
    end

    restart = @prompt.yes?("Would you like to see more #{keywords} recipes?")
    restart ? present(keywords) : self.end
  end

  def self.end
    puts 'Bon Appetit!'
  end
end
