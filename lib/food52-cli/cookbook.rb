# frozen_string_literal: true

# External Deps
require 'http'
require 'nokogiri'

# Searches and fetches recipes from food website, Food52.com
module Cookbook
  include HTTP
  include Nokogiri

  @base_url = 'https://food52.com'

  def self.search_by_keywords(keywords)
    keywords_formatted = keywords.strip.gsub(/\s/, '%20')

    raw_response = HTTP.get("#{@base_url}/recipes/search?q=#{keywords_formatted}&o=popular").to_s

    recipes = parse_recipes(raw_response)
    recipes
  end

  def self.search_by_ingredients(ingredients)
    main, *rest = ingredients
    main_ingredient = main.downcase
    rest_ingredients = rest.join(',').downcase

    raw_response = HTTP.get("#{@base_url}/recipes/search?q=#{main_ingredient}&tag=#{rest_ingredients}&o=popular").to_s

    recipes = parse_recipes(raw_response)
    recipes
  end

  def self.search_by_link(link)
    raw_response = HTTP.get("#{@base_url}#{link}").to_s

    recipes = parse_recipes(raw_response)
    recipes
  end

  def self.search_by_meal_type(meal)
    raw_response = HTTP.get("#{@base_url}/recipes/#{meal.downcase}").to_s

    recipes = parse_recipes(raw_response)
    recipes
  end

  def self.parse_recipes(raw_html)
    html_document = Nokogiri::HTML.parse(raw_html)

    recipes = {}
    html_document.css('div.card__details h3 a:first-child').each do |recipe|
      title = recipe['title']
      link = recipe['href']
      recipes.store(title, link)
    end

    raise 'No recipes found ' if recipes.empty?

    recipes
  end

  def self.show_recipe(recipe_link)
    raw_response = HTTP.get("#{@base_url}#{recipe_link}").to_s
    html_document = Nokogiri::HTML.parse(raw_response)

    ingredients = html_document.css('div.recipe__list.recipe__list--ingredients > ul > li').map do |ingredient|
      ingredient.text.gsub(/\R+/, ' ').strip
    end

    steps = html_document.css('div.recipe__list.recipe__list--steps > ol > li').map do |step|
      step.text.strip.delete("\n")
    end

    description = html_document.css('div.recipe__text > div.recipe__notes > p').text.strip

    { description: description, ingredients: ingredients, steps: steps }
  rescue StandardError => e
    raise "Failed to fetch recipe: #{e}"
  end

  def self.ingredients
    raw_response = HTTP.get("#{@base_url}/recipes/ingredient/all").to_s

    ingredients = parse_tags(raw_response)
    ingredients
  rescue StandardError => e
    raise "Failed to fetch ingredients: #{e}"
  end

  def self.cuisines
    raw_response = HTTP.get("#{@base_url}/recipes/cuisine/all").to_s

    cuisines = parse_tags(raw_response)
    cuisines
  rescue StandardError => e
    raise "Failed to fetch cuisines: #{e}"
  end

  def self.parse_tags(raw_response)
    html_document = Nokogiri::HTML.parse(raw_response)

    tags = {}
    html_document.css('div.recipe-tags__heading.content__container > ul > li > a').each do |tag|
      title = tag.text
      link = tag['href']
      tags.store(title, link)
    end

    tags
  end
end
