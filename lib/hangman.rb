require 'json'
require 'pry'

#UNIVERSAL VARIABLES
$already_played = []
$lives = 8
$win = 0
$game_loaded = 0

class Game
  def initialize (already_played, lives, win, dashboard, word)
    @already_played= already_played
    @lives= lives
    @win= win
    @dashboard= dashboard
    @word= word
  end 

  def to_json(already_played, lives, win, dashboard, word) 
    {
      "data" => {already_played: @already_played,
                  lives:  @lives,
                  win: @win,
                  dashboard: @dashboard,
                  word: @word
                }
            
    }.to_json
  end
end


def WordPick ()
  dictionary_lines = File.readlines "5desk.txt"
  $word = dictionary_lines[rand(61405)].chomp
 
  while $word.length < 4 do 
    $word = dictionary_lines[rand(61405)]
    break 
  end
  $word = $word.upcase.split("")
  $win = $word.length
end 

def checkinWinner
  if $win == 0
    puts "OH! you did it!"
    exit
  end
end

def LoadGame()

  puts "Loading data!"
  $game_loaded=1
  loaded_file = File.read("saved_games/save.txt")
  data_loaded = JSON.parse(loaded_file)
  loaded_data = data_loaded["data"]
  $already_played = loaded_data["already_played"]
  $lives = loaded_data["lives"]
  $word = loaded_data["word"]
  $win = loaded_data["win"]
  $dashboard = loaded_data["dashboard"]
  
  print $dashboard.join("")
  puts "   Status: #{$lives} lives left, #{$win} letter to guess and you already used #{$already_played}"
  
  humanPlay($dashboard)



  
  
end

def save(already_played, lives, win, dashboard, word)
  puts "Saving this Game"
  game = Game.new(already_played, lives, win, dashboard, word)
  json_string = game.to_json(already_played, lives, win, dashboard, word)
  
  File.write("saved_games/save.txt", json_string)


end


def humanPlay (dashboard)
  puts "Which letter will be your move? For SAVE game just type 'save'"
  
  player_says = gets.chomp.upcase
  twice = 0

  save($already_played, $lives, $win, $dashboard, $word) if player_says == "SAVE"

  #JUST TO GET OUT EASY OF THE GAME
  exit if player_says == "EXIT"
  
 
  
    $word.each_with_index do |l, i|
      if player_says == l 
        $dashboard[i] = " #{player_says} "
        puts "Well guessed!" unless twice == 1
        $lives +=1
        $lives -=1 if twice == 1
        twice = 1
        $win -= 1
             
      elsif player_says == "" || player_says.length > 1
        puts "Are you even playing? Just One letter, please"
        $lives +=1
        break

      elsif $already_played.include?(player_says)
        puts "Hey, you already played that! Careful"
        $lives +=1
        break

             
      end
      
    end
      
    $lives -=1
  $already_played.push(player_says) unless player_says.length > 1 || player_says == ""
  print $dashboard.join("")
  puts "   Status: #{$lives} lives left, #{$win} letter to guess and you already used #{$already_played}"
  
end
  
def Lose ()
  puts "Game over. Better luck next time, dude"
  puts "The word was #{$word.join("")}"
end
  
def welcome
  welcome = "  Welcome to IRB HangMan Game  "
  welcome = welcome.ljust(40, "#*")
  welcome = welcome.rjust(51, "#*")
  puts welcome

  instructions = "  You have 8 lives. Be wise  "
  instructions = instructions.ljust(40, "#*")
  instructions = instructions.rjust(51, "#*")
  puts instructions

  loadfile = File.zero?("saved_games/save.txt")
  #binding.pry
  unless loadfile
    puts "There is a saved game. Do you want to load it? (YES if affirmative / anykey if NO)"
    answer = STDIN.gets.chomp.downcase
    
      if answer == "yes"
        LoadGame()
      elsif answer == "no"
        
      end
    
  end

  if $game_loaded == 0
  WordPick()
  puts "Here comes your word! with #{$word.length} letters!"
  $dashboard = "_"*$word.length
  
  $dashboard = $dashboard.split("")
  puts $dashboard.join("")
  end
end

welcome()

while $lives > 0 do
  humanPlay($dashboard) 
  checkinWinner
end

Lose()


