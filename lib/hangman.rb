class Game
    def initialize
        @error_count = 6
        @word = select_word
        @guess_slots = create_slots
        @board = Board.new(@error_count, @word, @guess_slots)
        @board.display_board
        play_game
    end

    puts "Hangman initializing..."

    def select_word
        word_pool = File.readlines('word_dictionary.txt')
        word = ''
        until word.length >= 5 && word.length <= 12
            word = word_pool.sample.chomp
        end
        puts word
        word
    end

    def create_slots
        slots = []
        until slots.length == @word.length
            slots.push('_')
        end
        slots
    end
    
    def play_game
        guess = get_input
    end

    def get_input
        puts "Guess a letter"
        guess = gets.chomp.upcase
        until guess.length == 1
            puts "Error: type a single character to guess"
            guess = gets.chomp.upcase
        end
        guess
    end

    def check_guess(guess)
        unless @word.inlcude? guess
            @error_count -= 1
            @game.display_incorrect(guess)
        else
            update_slots(guess)
        end
        @game.display_board
    end

    def update_slots(guess)
    end
end

class Board
    def initialize(count, word, slots)
        @count = count
        @word = word
        @guess_slots = slots
    end

    def display_board
        puts "Incorrect guesses left: #{@count}"
        puts @guess_slots.join(' ')
    end

    def display_incorrect(guess)
        puts "The letter '#{guess}' is not in this word"
    end
end

Game.new