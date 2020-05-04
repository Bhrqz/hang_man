require "pry"

#UNIVERSAL VARIABLES
$already_played = []
$lives = 8

def WordPick ()
  dictionary_lines = File.readlines "5desk.txt"
  $word = dictionary_lines[rand(61405)].chomp
 
  while $word.length < 4 do 
    $word = dictionary_lines[rand(61405)]
    break 
  end
  $word = $word.upcase.split("")
end 

def humanPlay (dashboard)
  puts "Which letter will be your move?"
  
  player_says = gets.chomp.upcase
  
    $word.each_with_index do |l, i|
      if player_says == l
        dashboard[i] = " #{player_says} "
        puts "Well guessed!"
      elsif $already_played.include?(player_says)
        puts "Hey, you already played that! Careful"
        $lives +=1
        break
      elsif $already_played == nil
        puts "Are you even playing?"
        $lives +=1
        break
      end
      
    end
  
  $lives -=1
  $already_played.push(player_says)
  print dashboard.join("")
  puts "   Status: #{$lives} lives left and you already used #{$already_played}"
  end
  

welcome = "  Welcome to IRB HangMan Game  "
welcome = welcome.ljust(40, "#*")
welcome = welcome.rjust(51, "#*")
puts welcome

instructions = "  You have 8 lives. Be wise  "
instructions = instructions.ljust(40, "#*")
instructions = instructions.rjust(51, "#*")
puts instructions


WordPick()

#under THE HOOD Puts.... ERASE WHEN FINISHED!!!!
puts "CPU word is:  #{$word}"


puts "Here comes your word! with #{$word.length} letters!"
dashboard = "_"*$word.length

dashboard = dashboard.split("")
puts dashboard.join("")

while $lives > 0 do
humanPlay(dashboard) 
end

puts "Game over. Better luck next time, dude"




