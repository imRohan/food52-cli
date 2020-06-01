# frozen_string_literal: true

# External Deps
require 'tty-prompt'
require 'terminal-table'
require 'word_wrap'

# External Files
require_relative 'cookbook'

# Presents the user with conversation style interface to find recipes
module Chef
  @options = ['Search via keywords', 'By main ingredient'] 
  @prompt = TTY::Prompt.new

  def self.init
    option = @prompt.select('How would you like to search for recipes?', @options)

    parse_selection(option)
  end

  def self.parse_selection(option)
    keywords, ingredient = @options

    case option
    when keywords
      ask_for_keywords
    when ingredient
      show_ingredients
    else
      raise "Received invalid option: #{option}"
    end
  rescue StandardError => e
    puts "Failed to receive a proper response: #{e}"
  end

  def self.ask_for_keywords
    keywords = @prompt.ask('What would you like to eat today?')
    find_recipe_by_keywords(keywords)
  end

  def self.show_ingredients
    ingredients = Cookbook.ingredients
    ingredient_name = @prompt.select('Select main ingredient', ingredients.keys)
    find_recipe_by_ingredient(ingredients[ingredient_name])
  end

  def self.find_recipe_by_keywords(keywords)
    recipes = Cookbook.search_by_keywords(keywords)
    present_recipes(recipes)
  end

  def self.find_recipe_by_ingredient(ingredient_link)
    recipes = Cookbook.search_by_ingredient(ingredient_link)
    present_recipes(recipes)
  end

  def self.present_recipes(recipes)
    recipe_name = @prompt.select("Found #{recipes.length} recipes:", recipes.keys)
    recipe = Cookbook.show_recipe(recipes[recipe_name])

    description, ingredients, steps = recipe.values_at(:description, :ingredients, :steps)

    recipe_table = Terminal::Table.new do |table|
      table.title = recipe_name
      table.add_row [{ value: "Ingredients - #{ingredients.length} total", alignment: :center }]
      ingredients.each do |ingredient|
        table.add_row [ingredient]
      end
    end
    puts recipe_table

    puts
    puts 'Description'
    puts

    description_wraped = WordWrap.ww(description, 100)
    puts description_wraped

    puts
    puts 'Steps'
    puts

    steps.each.with_index(1) do |step, index|
      step_wraped = WordWrap.ww(step, 100)
      puts "#{index}) #{step_wraped} \n"
    end

    restart = @prompt.yes?('Would you like to keep looking?')
    restart ? init : self.end
  end

  def self.end
    puts 'Bon Appetit!'
  end
end
