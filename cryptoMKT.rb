# ###
# CryptoMKT API v1
# Documentation: https://developers.cryptomkt.com
# Limit: 10 request per minute
# ##
require 'time'
require 'faraday'
require 'json'
require 'dotenv'
Dotenv.load('.env.local', '.env') # Load .env.local config if exits

api_key = ENV['API_KEY']
secret_key  = ENV['SECRET_KEY']

timestamp = Time.now.to_i # Format to API - Unix Epoch

api = Faraday.new(:url => 'https://api.cryptomkt.com') # API Base URL

# Get Markets
# market = api.get '/v1/market'

# puts market.body

# Get Ticker
# ticker = api.get '/v1/ticker', { :market => 'ETHCLP' }

# puts ticker.body

# Get Balance
body = timestamp.to_s + '/v1/balance'

hashed = OpenSSL::HMAC.hexdigest('sha384', secret_key, body) # Signed Message With HMAC SHA384

balance = api.get do |req|
  req.url '/v1/balance'
  req.headers['Content-Type'] = 'application/json'
  req.headers['X-MKT-APIKEY'] = api_key
  req.headers['X-MKT-SIGNATURE'] = hashed
  req.headers['X-MKT-TIMESTAMP'] = timestamp.to_s
end

res = JSON.parse(balance.body)

puts '#####################'
puts '###### BALANCE ######'
puts '#####################'

res['data'].each do |data|
  puts 'Wallet:' + data['wallet']
  puts 'Available:' + data['available']
  puts 'Balance:' + data['balance']
  puts '------'
end



