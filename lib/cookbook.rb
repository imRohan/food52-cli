# frozen_string_literal: true

# External Deps
require 'http'
require 'nokogiri'

include HTTP
include Nokogiri

# Searches and fetches recipes from food website, Food52.com
module Cookbook
  def self.search(keywords)
    keywords_formatted = keywords.strip.gsub(/\s/, '%20')

    raw_response = HTTP.get("https://food52.com/recipes/search?q=#{keywords_formatted}").to_s
    html_document = Nokogiri::HTML.parse(raw_response)

    recipes = {}
    html_document.css('div.card__details h3 a:first-child').each do |recipe|
      title = recipe['title']
      link = recipe['href']
      recipes.store(title, link)
    end

    recipes
  rescue StandardError => e
    puts "Failed to search for recipes: #{e}"
  end

  def self.get(recipe_link)
    recipe = { description: '', ingredients: [], steps: [] }

    raw_response = HTTP.get("https://food52.com#{recipe_link}").to_s
    html_document = Nokogiri::HTML.parse(raw_response)

    html_document.css('div.recipe__list.recipe__list--ingredients > ul > li').each do |ingredient|
      item = ingredient.text.gsub(/\R+/, ' ').strip
      recipe[:ingredients].push(item)
    end

    html_document.css('div.recipe__list.recipe__list--steps > ol > li').each do |step|
      step = step.text.strip.delete("\n")
      recipe[:steps].push(step)
    end

    recipe[:description] = html_document.css('div.recipe__text > div.recipe__notes > p').text.strip

    recipe
  rescue StandardError => e
    puts "Failed to fetch recipe: #{e}"
  end
end
