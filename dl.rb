#!/usr/bin/env ruby
# encoding: utf-8

require "open-uri"
require "optparse"
require_relative 'iconfinder_api'

options = {}
path = 'img'

optparse = OptionParser.new do |opts|
  opts.banner = "Command-line tool for downloading icons from https://www.iconfinder.com\n"
  opts.banner += "Copyright (c) 2014 Zhussupov Zhassulan zhzhussupovkz@gmail.com\n"
  opts.banner += "While using this program, get API key from https://www.iconfinder.com.\nUsage: dl.rb [options]"

  opts.on('-h', '--help', "help page") do
    puts opts
    exit
  end

  opts.on('-q', '--query QUERY', "search for icons by search term") do |q|
    options[:q] = q
  end

  opts.on('-d', '--directory DIRECTORY', "folder, which will be uploaded icons") do |dir|
    path = dir
  end

  opts.on('-p', '--page PAGE', "specify result page(index). starts from 0") do |page|
    options[:page] = page
  end

  opts.on('-c', '--count COUNT', "number of icons per page") do |c|
    options[:c] = c
  end

  opts.on('-i', '--min MIN', "specify minimum size of icons") do |min|
    options[:min] = min
  end

  opts.on('-a', '--max MAX', "specify maximum size of icons") do |max|
    options[:max] = max
  end
end

optparse.parse!
if options.empty?
  p optparse
  exit
end

if not path or path == false
  path = 'img'
end

query = options[:q]
path = File.dirname(__FILE__) + '/' + path.to_s
Dir.mkdir(path) unless File.exists?(path)

ic = IconfinderApi.new 'your api key'

result = ic.search options
puts "Find " + result.length.to_s + " icons"
puts "Downloading icons to " + path.to_s + " directory."
result.each do |e|
  filename = File.basename e['image']
  begin
    open(e['image'], 'rb') do |img|
      File.new("#{path}/#{filename}", 'wb').write(img.read)
      puts "Icon '" + filename + "': OK" 
    end
  rescue Exception => e
    next
  end
end

puts "Successfully download " + result.length.to_s + " icons."
