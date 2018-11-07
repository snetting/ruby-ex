#!/usr/bin/env ruby

require 'json'
require 'sinatra'
require './cpcdb.rb'

DBFILE = "cpc.dat"
myDB = DB.new(DBFILE)

rand_topic = 100

myDB.load

get '/lookup' do
  mdsum = params['mdsum']
  #fname = params['fname']
  puts "Caught input: #{mdsum}"
  stermstring = mdsum.downcase
  puts "Queried: #{stermstring}"
  result = myDB.query(stermstring)
  p JSON.generate("#{result}")
end
