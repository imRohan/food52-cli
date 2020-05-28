#!usr/bin/env ruby

# External Deps
require 'tty-prompt'

# External Files
require_relative 'cookbook'
include Cookbook

prompt = TTY::Prompt.new

name = prompt.ask('What is your name?')
Cookbook.search(name)
