require 'yaml'

class Game
    def initialize
        setup
    end
# setup game variables
    def setup
        @word = select_word.downcase
        @word_array = @word.split("")
        @guess_slots = create_slots
        @error_count = 10
        @guessed_letters = []
        @board = Board.new
    end
# sample the dictionary text file until a word between 5 and 12 characters
# is found
    def select_word
        word_pool = File.readlines('word_dictionary.txt')
        word = ''
        until word.length >= 5 && word.length <= 12
            word = word_pool.sample.chomp
        end
        word
    end
# create the letter slots for the guesses
    def create_slots
        slots = []
        until slots.length == @word.length
            slots.push('_')
        end
        slots
    end
# play the game until the player has guessed the word or has run
# out of errors, then display the appropriate end message
    def play_game
        @board.display_board(@error_count, @guess_slots, @guessed_letters)
        until @guess_slots == @word_array || @error_count == 0
            guess = get_input
            if guess == "save game"
                @board.display_saved
                save_game
            else
                check_guess(guess)
            end
            @board.display_board(@error_count, @guess_slots, @guessed_letters)
        end
        finish_game
    end
# get the player's input and check that the input is a single character
    def get_input
        @board.gets_prompt
        guess = gets.chomp.downcase
        until (@guessed_letters.include? guess) == false && (guess.length == 1 || guess == "save game")
            if @guessed_letters.include? guess
                @board.error_prompt(2, guess)
            else
                @board.error_prompt(1, guess)
            end
            guess = gets.chomp.downcase
        end
        guess
    end
# check to see if the player has guessed correctly, update related
# variables, and display the board
    def check_guess(guess)
        unless @word.include? guess
            @error_count -= 1
            @board.display_incorrect(guess)
        else
            @board.display_correct(guess)
            update_slots(guess)
        end
        @guessed_letters.push(guess)
    end
# update the guess slots with the player's guess character
    def update_slots(guess)
        @word_array.each_with_index do |char, index|
            if guess == char
                @guess_slots[index] = guess
            end
        end
    end
# check if the player won or lost and return the appropriate
# message
    def check_game
        if @guess_slots == @word_array
            return "You have won the game!"
        else
            return "Your man is hanged! You have lost!"
        end
    end
# finish the game and check if the player wants to play again
    def finish_game
        @board.display_end_game(check_game)
        @board.display_continue
        choice = gets.chomp.downcase
        until choice == "play again" || choice == ""
            @board.error_prompt(1, choice)
            choice = gets.chomp.downcase
        end
        if choice == "play again"
            @board.display_new_game_header
            setup
            play_game
        else
            @board.display_goodbye
        end
    end
# YAML save and load methods
    def save_game
        File.open('./saved_game.yml', 'w') { |file| file.write(YAML.dump(self)) }
    end
    def self.load_game
        YAML.safe_load(File.read('./saved_game.yml'), permitted_classes: [Game, Board])
    end
end

class Board
# display gets prompt
    def gets_prompt
        puts "Guess a letter, or type 'save game' to save the game"
    end
# display that the game was saved
    def display_saved
        puts "This game was saved successfully"
        space
    end
# display error prompt
    def error_prompt(error, guess)
        if error == 1
            puts "Error: '#{guess.upcase}' is not a valid input"
        elsif error == 2
            puts "Error: You have already guessed '#{guess.upcase}'"
        end
        space
    end
# display the error count and the guess slots
    def display_board(count, slots, guessed_letters = ["none yet"])
        puts "Incorrect guesses left: #{count}"
        puts "Guessed letters: #{guessed_letters.join(", ")}"
        puts slots.join(' ')
        space
    end
# indicate that the player's guess is in the word
    def display_correct(guess)
        puts "The letter '#{guess.upcase}' is in this word"
    end
# indicate that the player's guess is not in the word
    def display_incorrect(guess)
        puts "The letter '#{guess.upcase}' is not in this word"
    end
# indicate that the player has either won or lost
    def display_end_game(message)
        puts message
    end
# ask the player if they wish to play again
    def display_continue
        space
        puts "If you would like to play again, type 'play again' and hit enter"
        puts "Otherwise, just hit enter"
    end
# display the new game header
    def display_new_game_header
        space
        puts "Here is your new game!"
    end
# tell the player goodbye
    def display_goodbye
        space
        puts "Thanks for playing! Goodbye..."
    end
# used to separate messages
    def space
        puts ""
    end
end

def game_menu
    puts "Welcome to Hangman!"
    puts "To load a game, type 'load game' and press enter"
    puts "To start a new game, just press enter"
    choice = gets.chomp.downcase
    until choice == "load game" || choice == ""
        puts "invalid input"
        choice = gets.chomp.downcase
    end
    if choice == "load game"
        this_game = Game.load_game
    else
        this_game = Game.new
    end
    this_game.play_game
end

game_menu