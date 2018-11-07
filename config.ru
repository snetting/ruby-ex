#!/usr/bin/env ruby

require 'json'
require 'sinatra'
#require './cpcdb.rb'

class DB

  def initialize(db)
    @databasename=db
    @database = Array.new
    @sterms = Array.new
    @resultdata = Array.new
  end
  def load
    if File.exist?("#{@databasename}")
      p "- Found existing #{@databasename}"
      @database = IO.readlines("#{@databasename}")
      p "- imported #{@database.size} facts"
      return @database.size
    else
      p "- #{@databasename} not found"
    end
  end
  def size
    p "#{@database}"
    return @database.size
  end

  def query(instring)
    p "HIT DB with query #{instring}"
    @scoredata = Array.new(@database.size, 0)
    @stermstring = instring
    @sterm = @stermstring
    p "filtered query = #{@sterm}"
    result = "NOTFOUND"
      p "working on sterm: #{@sterm}"
      @database.each_with_index do |val, index|
        #puts "- searching #{index}, value #{val}"
        #val.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        if val =~ /\b#{Regexp.escape(@sterm)}s?\b/ then
          puts "Found match for #{@sterm}, index #{index}"  #, data: #{val}"
          result = @database[index].sub(/.*?  /, '')
          puts "database VALUE #{val} AT INDEX #{index}"
          puts "database RESULT; #{result}"
        end
      end
      #puts "DB RETURNS #{result}"
      return result
  end
end

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
