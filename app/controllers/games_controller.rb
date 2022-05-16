require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    8.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def all_letter_in_grid?(word, grid)
    letters = word.chars.reject { |letter| grid.include?(letter) }
    letters.empty?
  end

  def score_calculus(word)
    word.size**2
  end

  def score
    @tested_word = params[:word].upcase
    @letters = params[:letters].chars
    @score = session[:score].to_i || 0
    @response = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@tested_word}").read)
    if @response['found']
      @score += score_calculus(@tested_word)
      @answer = "#{@tested_word} exists in my dictionnary ! You gained #{score_calculus(@tested_word)} points!"
    elsif all_letter_in_grid?(@tested_word, @letters)
      @answer = "Sorry but #{@tested_word} does not seem to be an english word"
    else
      @answer = "Sorry but #{@tested_word} can't be build out of #{@letters.join(', ')}"
    end
  end


end
