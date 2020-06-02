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

  INITIAL_OPTIONS = %w[Keywords Ingredients Cuisine Meal].freeze
  OPTIONS_PER_PAGE = 30

  def self.init
    option = @prompt.select('How would you like to search for recipes?', INITIAL_OPTIONS)

    parse_selection(option)
  end

  def self.parse_selection(option)
    keywords, ingredient, cuisine, meal = INITIAL_OPTIONS

    case option
    when keywords
      ask_keywords
    when ingredient
      ask_ingredients
    when cuisine
      ask_cuisines
    when meal
      ask_meal_types
    else
      raise "Received invalid option: #{option}"
    end
  rescue StandardError => e
    handle_errors(e)
  end

  def self.ask_keywords
    keywords = @prompt.ask('What would you like to eat today?')

    recipes = Cookbook.search_by_keywords(keywords)
    present_recipes(recipes)
  rescue StandardError => e
    handle_errors(e)
  end

  def self.ask_ingredients
    ingredients = Cookbook.ingredients
    ingredients_selected = @prompt.multi_select('Select ingredients', ingredients.keys, per_page: OPTIONS_PER_PAGE)

    recipes = Cookbook.search_by_ingredients(ingredients_selected)
    present_recipes(recipes)
  rescue StandardError => e
    handle_errors(e)
  end

  def self.ask_cuisines
    cuisines = Cookbook.cuisines
    cuisine_name = @prompt.select('Select a cuisine', cuisines.keys, per_page: OPTIONS_PER_PAGE)

    recipes = Cookbook.search_by_link(cuisines[cuisine_name])
    present_recipes(recipes)
  rescue StandardError => e
    handle_errors(e)
  end

  def self.ask_meal_types
    meals = %w[Breakfast Brunch Lunch Dinner Snacks]
    meal = @prompt.select('Select a meal', meals, per_page: OPTIONS_PER_PAGE)

    recipes = Cookbook.search_by_meal_type(meal)
    present_recipes(recipes)
  rescue StandardError => e
    handle_errors(e)
  end

  def self.present_recipes(recipes)
    recipe_name = @prompt.select('Select a recipe to view', recipes.keys, per_page: OPTIONS_PER_PAGE)
    recipe = Cookbook.show_recipe(recipes[recipe_name])

    description, ingredients, steps = recipe.values_at(:description, :ingredients, :steps)

    recipe_table = generate_ingredient_table(recipe_name, ingredients)
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

    askToRestart
  rescue StandardError => e
    handle_errors(e)
  end

  def self.generate_ingredient_table(recipe_name, ingredients)
    ingredient_table = Terminal::Table.new do |table|
      table.title = recipe_name
      table.add_row [{ value: "Ingredients - #{ingredients.length} total", alignment: :center }]
      ingredients.each do |ingredient|
        table.add_row [ingredient]
      end
    end

    ingredient_table
  end

  def self.handle_errors(error)
    puts "Failed to find recipe: #{error}"
    ask_to_restart
  end

  def self.ask_to_restart
    restart = @prompt.yes?('Search for another recipe?')
    restart ? init : exit
  end
end
