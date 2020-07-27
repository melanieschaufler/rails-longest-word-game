require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    @letters = []
    10.times { |i| @letters[i] = alphabet.sample }
    session[:passed_variables] = @letters
  end

  def score
    attempt = params[:word]
    word = session[:passed_variables]

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)

    if user["found"]
      @results = correct_words(attempt, word)
    else
      @results = "#{params[:word]} is not an english word"
    end
  end

  private

  def correct_words(attempt, grid)
    if attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
      message = "Well done! #{attempt} is in the grid"
    else
      message = "#{attempt} is not in the grid"
    end
      message
  end
end
