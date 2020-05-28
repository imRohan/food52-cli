#!usr/bin/env ruby

# External Deps
require 'tty-prompt'

# External Files
require_relative 'cookbook'
include Cookbook

prompt = TTY::Prompt.new

name = prompt.ask('What would you like to eat today?')
Cookbook.search(name)
