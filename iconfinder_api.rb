=begin
/*

The MIT License (MIT)

Copyright (c) 2014 Zhussupov Zhassulan zhzhussupovkz@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
=end

require 'net/http'
require 'net/https'
require 'json'
require 'openssl'
require 'base64'

class IconfinderApi

  def initialize api_key
    @api_key = api_key
    @api_url = 'https://www.iconfinder.com/json/'
  end

  #send request to the server
  def send_request method, params = nil
    if params.nil?
      raise ArgumentError, "Invalid request params"
    else
      required = { 'api_key' => @api_key }
      params = required.merge(params)
      params = URI.escape(params.collect{ |k,v| "#{k}=#{v}"}.join('&'))
    end
    url = @api_url + method + '/?' + params
    raise ArgumentError, "Can't send request to the server" if not url.is_a? String
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)
    data = res.body
    if not data.is_a? String or not data.is_json?
      raise RuntimeError, "Server returned incorrect format data."
    end
    result = JSON.parse(data)
  end

  #search for icons by search term
  def search query = 'icon', page = 0, c = 10, min = 1, max = 48
    params = {'q' => query, 'p' => page, 'c' => c, 'min' => min, 'max' => max, 'l' => 0, 'price' => 'any' }
    json = send_request 'search', params
    json['searchresults']['icons']
  end

  #get information about an icon
  def icondetails id = 1, size = 128
    params = { 'id' => id, 'size' => size }
    json = send_request 'icondetails', params
    json['icon']
  end

end

#checking if string is JSON
class String
  def is_json?
    begin
      !!JSON.parse(self)
    rescue
      false
    end
  end
end