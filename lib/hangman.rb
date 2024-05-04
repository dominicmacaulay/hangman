puts "Hangman initializing..."

def select_word
    word_pool = File.readlines('word_dictionary.txt')
    word = ''
    until word.length >= 5 && word.length <= 12
        word = word_pool.sample.chomp
    end
    word
end

puts select_word