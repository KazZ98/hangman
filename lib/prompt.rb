module Prompt
  def header_prompt
    puts "-- Hangman Game --\n\n"
    puts "Type 'load' to load a game or 'save' to save current game\n\n"
  end

  def current_word_prompt(word)
    puts "Secret word: #{word.join}"
  end

  def attempts_left_prompt(attempts)
    puts "Attempts left: #{attempts}\n\n"
  end

  def wrong_guesses_prompt(guesses)
    puts "Wrong guesses: #{guesses.join(' ')}\n\n"
  end

  def guess_prompt
    puts '- Type your guess:'
  end

  def save_prompt
    puts "\n- Type a name to save:"
  end

  def load_prompt
    puts "\n- Type the name to load:"
  end

  def secret_word_prompt(word)
    puts "The secret word was: '#{word.join}'"
  end

  def invalid_load_prompt(file_name)
    puts "No such a file named: '#{file_name}'. Try again\n\n"
  end

  def valid_command_prompt(command, file_name)
    puts "Success to #{command} game: '#{file_name}'\n\n"
  end

  def update_display
    system "clear"
  end

  def winner_prompt
    puts "You win the game!\n\n"
  end

  def loser_prompt
    puts "You lose the game.\n\n"
  end

  def play_again_prompt
    puts "- Type 'y' if you want play a new game or any other key to exit."
  end

  def player_input
    gets.chomp.downcase.strip
  end
end