#!/usr/bin/env ruby
# encoding: utf-8

require "open-uri"
require_relative 'iconfinder_api'

query = ARGV[0]
path = File.dirname(__FILE__) + '/' + ARGV[1].to_s
Dir.mkdir(path) unless File.exists?(path)

ic = IconfinderApi.new 'your api key'

result = ic.search query.to_s
result.each do |e|
  filename = File.basename e['image']
  begin
    open(e['image'], 'rb') do |img|
      File.new("#{path}/#{filename}", 'wb').write(img.read)
    end
  rescue Exception => e
    next
  end
end