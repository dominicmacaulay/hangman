class Game
    def initialize
        @error_count = 6
        @word = select_word
        @board = Board.new(@error_count, @word)
        puts @board.display_board
    end

    puts "Hangman initializing..."

    def select_word
        word_pool = File.readlines('word_dictionary.txt')
        word = ''
        until word.length >= 5 && word.length <= 12
            word = word_pool.sample.chomp
        end
        word
    end
    
end

class Board
    def initialize(count, word)
        @count = count
        @word = word
        @guess_slots = []
        create_display
    end

    def create_display
        until @guess_slots.length == @word.length
            @guess_slots.push('_')
        end
    end

    def display_board
        @guess_slots.join(' ')
    end
end

Game.new