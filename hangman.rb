require "yaml"


class Array
	def to_string
		string = ""
		self.each do |x|
			string << x
		end
		return string
	end
end


class Game
	attr_reader :target
	attr_reader :wrong_guesses
	attr_writer :wrong_guesses
	attr_reader :wrong_letters
	attr_writer :wrong_letters
	attr_reader :letters_left
	attr_writer :letters_left
	attr_reader :guess
	attr_writer :guess
	attr_reader :continue
	attr_reader :valid
	attr_reader :save
	attr_reader :game
	attr_writer :game

	def initialize
		@game_name =""
		dictionary = get_dict("dictionary.txt")
		@target = get_target(dictionary)
		@wrong_guesses =0
		@wrong_letters =[]
		@letters_left =@target.length
		@guess = make_guess(@target)
		@continue = true
		@valid = true
		@save = false
	end

	def get_dict(dictionary_file)
		contents = File.readlines(dictionary_file)
		dictionary = contents.collect do |word|
			word if word.length > 5 && word.length <12
		end
		dictionary.compact!
	end

	def get_target(dictionary)
		dictionary[rand(dictionary.length)].strip.chars
	end

	def make_guess(target)
		guess = []
		until guess.size==target.size
		guess.push("_")
		end
		return guess
	end

	def check_guess(letter_guess, target)
		if target.include?(letter_guess)
			indices = []
			target.each_with_index do |char, index|
				if char==letter_guess
					indices.push(index)
				end
			end
			return indices
		end
	end

	def play
		@valid =true
		puts "Guess: "
		letter_guess = gets.chomp
		if letter_guess == "save"
			save_game
			return @save = true
		elsif letter_guess == "quit"
			return @continue = false
		elsif letter_guess.length>1
			return @valid = false
		end
		result = check_guess(letter_guess,@target)
		if result.nil?
			@wrong_letters.push(letter_guess)
			@wrong_guesses +=1
		else
			result.each do |index|
				@guess[index] = letter_guess
				@letters_left -=1
			end
		end
		puts "Current guess " + @guess.to_string
		puts "Wrong guesses [" + @wrong_letters.to_string+ "]"
		puts "You have guessed wrong #{@wrong_guesses} many times."
		puts "you have #{@letters_left} letters left."
	end

	def display
		puts "Current guess " + @guess.to_string
		puts "Wrong guesses [" << @wrong_letters.to_string << "]"
		puts "You have guessed wrong #{@wrong_guesses} many times."
		puts "you have #{@letters_left} letters left."
	end
end


def load_game
	to_save = File.open('games/saved_games.yaml','r'){|file| file.read}
	YAML.load(to_save)
end

def save_game
	Dir.mkdir('games') unless Dir.exist? 'games'
	filename = 'games/saved_games.yaml'
	File.open(filename, 'w') do |file|
		file.puts YAML.dump(self)
	end
end





puts "Let's play HANGMAN"
puts "at any time you may,"
puts "enter 'quit' to exit without saving"
puts "enter 'save' to save and exit"


puts "load?"
	if gets.chomp == "yes"
		game = load_game
		game.display
	else
		game = Game.new
	end




puts "8 wrong guesses and you lose."

until game.letters_left == 0 || game.wrong_guesses==8
	game.play
	if !game.continue
		break
	elsif !game.valid
		puts "invalid input. please enter 1 letter at a time."
	elsif game.save
		puts "your game has been saved. see you soon."
	end
end

if game.wrong_guesses ==8
	puts "YOU LOSE"
elsif game.letters_left ==0
	puts "YOU WIN"
end







