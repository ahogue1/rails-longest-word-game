require 'open-uri'

class WordsController < ApplicationController

  def game
    @letters = Array.new(7) { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:answer]
    @grid = params[:grid]
    @time_taken = Time.now - Time.parse(params[:start_time])
    score_and_message
  end

  def included?(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def score_and_message
    if included?(@attempt.upcase, @grid)
      if english_word?(@attempt)
        @score = @time_taken > 60.0 ? 0 : @attempt.size * (1.0 - @time_taken / 60.0)
        @message = "You win!"
      else
        @message = "This isn't an English word"
        @score = 0
      end
    else
      @message = "This word is not in the given letters"
      @score = 0
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end

