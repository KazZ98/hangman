require_relative 'prompt'
require 'yaml'

WORDS_FILE = 'words.txt'

class Hangman
  include Prompt

  attr_accessor :secret_word, :guessed_word, :wrong_guesses, :attempts

  def initialize
    @secret_word = random_word
    @guessed_word = blank_word
    @wrong_guesses = []
    @attempts = 12
  end

  def play
    loop do
      header_prompt
      current_word_prompt(guessed_word)
      attempts_left_prompt(attempts)
      wrong_guesses_prompt(wrong_guesses)
      guess_prompt

      guess = player_input

      case guess
      when 'save'
        save_game(guess)
      when 'load'
        load_game(guess)
      else
        update_guessed_word(guess)
        update_wrong_guesses(guess)
        self.attempts -= 1

        if game_over?
          secret_word_prompt(secret_word)

          play_again? ? reset_game : break
        end
        update_display
      end
    end
  end

  private

  def random_word
    words = File.readlines(WORDS_FILE, chomp: true)
    random_word = words.select { |word| word.size.between?(5, 12) }.sample
    random_word.split('')
  end

  def blank_word
    secret_word.map { '_' }
  end

  def update_guessed_word(player_char)
    secret_word.each_with_index do |char, index|
      guessed_word[index] = char if char.eql?(player_char)
    end
  end

  def update_wrong_guesses(player_char)
    unless wrong_guesses.include?(player_char) || secret_word.include?(player_char)
      wrong_guesses << player_char
    end
  end

  def game_over?
    update_display

    if guessed_word.eql?(secret_word)
      winner_prompt
      return true
    end

    if attempts.zero?
      loser_prompt
      return true
    end
  end

  def play_again?
    play_again_prompt
    player_input == 'y'
  end

  def reset_game
    self.secret_word = random_word
    self.guessed_word = blank_word
    self.wrong_guesses = []
    self.attempts = 12
  end

  def save_game(command)
    save_prompt
    file_name = player_input
    state = {
      secret_word: secret_word,
      guessed_word: guessed_word,
      wrong_guesses: wrong_guesses,
      attempts: attempts
    }

    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{file_name}_save.yml", "w") { |file| file.write(state.to_yaml) }

    update_display
    valid_command_prompt(command, file_name)
  end

  def load_game(command)
    load_prompt
    file_name = player_input

    unless File.file?("saves/#{file_name}_save.yml")
      update_display
      invalid_load_prompt(file_name)
    else
      state = YAML.load(File.read("saves/#{file_name}_save.yml"))

      self.secret_word = state[:secret_word]
      self.guessed_word = state[:guessed_word]
      self.wrong_guesses = state[:wrong_guesses]
      self.attempts = state[:attempts]

      update_display
      valid_command_prompt(command, file_name)
    end
  end
end