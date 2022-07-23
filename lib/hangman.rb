require "yaml"

WORDS_FILE = 'words.txt'

class Hangman
  attr_accessor :guessed_word, :secret_word, :attempts

  def initialize
    @secret_word = random_word
    @guessed_word = secret_word.map { '_' }
    @attempts = 12
  end

  def play
    until game_over?
      show_stats
      guess = gets.chomp.downcase

      case guess
      when 'save'
        save_game
      when 'load'
        puts load_game
      else
        update_guessed_word(guess)
        self.attempts -= 1
      end
    end
  end

  private

  def random_word
    words = File.readlines(WORDS_FILE, chomp: true)
    random_word = words.select { |word| word.size.between?(5, 12) }.sample
    random_word.split('')
  end

  def update_guessed_word(player_char)
    secret_word.each_with_index do |char, index|
      guessed_word[index] = char if char.eql?(player_char)
    end
  end

  def game_over?
    guessed_word.eql?(secret_word) || attempts.zero?
  end

  def show_stats
    p attempts
    p guessed_word
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')

    name = gets.chomp.downcase
    state = {
      secret_word: secret_word,
      guessed_word: guessed_word,
      attempts: attempts
    }

    File.open("saves/#{name}_save.yml", "w") { |file| file.write(state.to_yaml) }
  end

  def load_game
    name = gets.chomp.downcase

    return 'no such a file' unless File.file?("saves/#{name}_save.yml")

    state = YAML.load(File.read("saves/#{name}_save.yml"))
    self.secret_word = state[:secret_word]
    self.guessed_word = state[:guessed_word]
    self.attempts = state[:attempts]

    'file loaded'
  end
end