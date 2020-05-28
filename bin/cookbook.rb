# External Deps
require 'http'
include HTTP

module Cookbook
  def search (keyword)
    puts "Searching for #{keyword}"

    begin
      raw_response = HTTP.get("https://food52.com/recipes/search?q=#{keyword}")
      puts raw_response
    rescue Exception => error
      puts "Failed to search for recipes: #{error}" 
    end
  end
end
