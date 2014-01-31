#!/usr/bin/env ruby
# encoding: utf-8

require "open-uri"
require "optparse"
require_relative 'iconfinder_api'

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: dl.rb [options]"

  opts.on('-h', '--help', "help page") do
    puts opts
    exit
  end

  opts.on('-q', '--query QUERY', "search for icons by search term") do |q|
    options[:q] = q
  end

  opts.on('-d', '--directory DIRECTORY', "folder, which will be uploaded icons") do |dir|
    options[:path] = dir
  end
end

optparse.parse!
if ARGV.empty?
  p optparse
  exit
end

query = options[:q]
path = File.dirname(__FILE__) + '/' + options[:path].to_s
Dir.mkdir(path) unless File.exists?(path)

ic = IconfinderApi.new 'your api key'

result = ic.search query.to_s
puts "Find " + result.length.to_s + " icons"
puts "Downloading icons to " + ARGV[1].to_s + " directory."
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