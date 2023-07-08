class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""

  end

  def guess(g_letter)
    raise ArgumentError, "Argument is nil" if g_letter.nil?
    raise ArgumentError, "Argument needs to be word character" unless g_letter.match?(/^\w+$/)
  
    if g_letter.length == 1 && ((@guesses.include?(g_letter.downcase)) || (@wrong_guesses.include?(g_letter.downcase)))
      return false
    end 
  
    g_letter.downcase.each_char do |char|
      if @word.include?(char) && !(@guesses.include?(char))
        @guesses += char
      elsif !(@wrong_guesses.include?(char))
        @wrong_guesses += char 
      end
    end
  end

  def word_with_guesses()
    result = @word.chars.map do |char| 
      if guesses.include?(char)
        char
      else
        "-"
      end
    end 
    return result.join("")
  end 

  def check_win_or_lose()
    if @wrong_guesses.length >= 7
      return :lose
    end
    
    all_guess = @word.chars.uniq - @guesses.chars

    if all_guess.empty?
      return :win
    else
      return :play
    end 
    
  end 

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    } 
  end

end
