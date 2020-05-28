# External Deps
require 'tty-prompt'
require 'terminal-table'

# External Files
require_relative 'cookbook'
include Cookbook

module Chef
  def self.ask
    prompt = TTY::Prompt.new
    
    name = prompt.ask('What would you like to eat today?')
    recipes = Cookbook.search(name)

    recipe_name = prompt.select("Heres what I found, which one would you like to read?", recipes.keys)
    recipe = Cookbook.get(recipes[recipe_name])

    recipe_table = Terminal::Table.new do | table |
      table.title = recipe_name
      table.add_row [ { value: 'Ingredients', alignment: :center } ]
      recipe[:ingredients].each do | ingredient |
        table.add_row [ ingredient ]
      end
    end

    puts recipe_table

    puts "---Steps---"
    recipe[:steps].each.with_index(1) do | step, index |
      puts "#{index}) #{step} \n"
    end
  end
end

