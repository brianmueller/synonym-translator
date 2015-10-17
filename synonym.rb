# http://ruby-doc.org/stdlib-2.0.0/libdoc/open-uri/rdoc/OpenURI.html 
require 'open-uri'
# https://github.com/flori/json
require 'json'
# http://stackoverflow.com/questions/9008847/what-is-difference-between-p-and-pp
require 'pp'

require 'json'
# value = '{"val":"test","val1":"test1","val2":"test2"}'
# puts JSON.parse(value) # => {"val"=>"test","val1"=>"test1","val2"=>"test2"}

# Construct the URL we'll be calling
request_uri = 'http://words.bighugelabs.com/api/2/4e3076d3a640424d1b00f7ab3b7d5f91/'
request_query = 'ball'
url = "#{request_uri}#{request_query}/json"

# Actually fetch the contents of the remote URL as a String.
buffer = open(url).read

# puts JSON.parse(buffer)["noun"]["syn"].sample

def get_synonym(word)
  JSON.parse(open("http://words.bighugelabs.com/api/2/4e3076d3a640424d1b00f7ab3b7d5f91/#{word}/json").read)["noun"]["syn"].sample
#   JSON.parse(open("http://words.bighugelabs.com/api/2/4e3076d3a640424d1b00f7ab3b7d5f91/#{word}/json").read)
end

require 'unirest'

def is_noun?(word)
  response = Unirest.get "https://wordsapiv1.p.mashape.com/words/#{word}",
    headers:{
      "X-Mashape-Key" => "zuXTIGm8drmshzKubwZLBRQNV0sFp1XDtp5jsnOKpYs4VuyWsC",
      "Accept" => "application/json"
    }
  result = response.body
  
  part_of_speech = nil # empty to begin with
  unless result["results"].nil? # unless there's no result
    part_of_speech = result["results"][0]["partOfSpeech"] # set the part of speech
  end

  if part_of_speech == "noun"
    return true
  else
    return false
  end
end

def translate(sentence)
  sentence_array = sentence.split(" ")
  new_sentence_array = []
  sentence_array.each do |word|
    if is_noun?(word)
      new_sentence_array << get_synonym(word)
    else
      new_sentence_array << word
    end
  end
  new_sentence_array.join(" ")
end

def run
  puts "What would you like to translate?"
  sentence = gets.chomp
  puts translate(sentence)
end

run()