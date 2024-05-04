class Game
    def initialize
        @word = select_word.downcase
        @word_array = @word.split("")
        @guess_slots = create_slots
        @error_count = 6
        @guessed_letters = []
        @board = Board.new
        @board.display_board(@error_count, @guess_slots)
        play_game
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
        until @guess_slots == @word_array || @error_count == 0
            guess = get_input
            check_guess(guess)
        end
        @board.display_end_game(check_game)
    end
# get the player's input and check that the input is a single character
    def get_input
        @board.gets_prompt
        guess = gets.chomp.downcase
        until guess.length == 1
            @board.error_prompt
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
        @board.display_board(@error_count, @guess_slots, @guessed_letters)
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
end

class Board
# displays initialize message
    def initialize
        puts "Hangman initializing..."
        space
    end
# display gets prompt
    def gets_prompt
        puts "Guess a letter"
    end
# display error prompt
    def error_prompt
        puts "Error: type a single character to guess"
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
        puts "The letter '#{guess}' is in this word"
    end
# indicate that the player's guess is not in the word
    def display_incorrect(guess)
        puts "The letter '#{guess}' is not in this word"
    end
# indicate that the player has either won or lost
    def display_end_game(message)
        puts message
    end
# used to separate messages
    def space
        puts ""
    end
end

Game.new