require 'securerandom'

Rows = 9
Columns = 9

@gameover = false
list_of_letters = "ABCDEFGHI"
@square = ""
white_space_number = 24
Letter_map = {
  "A" => 0,
  "B" => 1,
  "C" => 2,
  "D" => 3,
  "E" => 4,
  "F" => 5,
  "G" => 6,
  "H" => 7,
  "I" => 8
}

@front_board = Array.new(Rows) { |i| Array.new(Columns) { |i| "_" }}
@back_board = Array.new(Rows) { |i| Array.new(Columns) { |i| 0 }}

def nl()
  print("\n")
end

def fill_back_board_bomb()
  bomb_count = 10
  while bomb_count != 0
    row_bomb_index = SecureRandom.random_number(9)
    column_bomb_index = SecureRandom.random_number(9)
    if @back_board[row_bomb_index.to_i][column_bomb_index.to_i] == 0
      @back_board[row_bomb_index][column_bomb_index] = "*"
      bomb_count -= 1
    end

  end
end

def in_board(row , column)
  if ( (row >= 0 && row <= 8) && ( (column >= 0 && column <= 8) )) 
    return true
  end
  return false
end

def fill_back_board_numbers()
  for i in 0..8 do
    for j in 0..8 do
      if @back_board[i][j] == "*"
        for x in i-1..i+1 do
          for y in j-1..j+1 do
            if(in_board( x , y ) && !(x == i &&  y == j))
              if(@back_board[x][y] != "*")
                @back_board[x][y] = @back_board[x][y].to_i + 1
              end
            end
          end
        end
      end
    end
  end
end

def board_boarders()
  for letter in "A".."I" do
    print("\t#{letter}")
  end
  nl()
  nl()
end

def front_board_display()
  row_number = 1
  for rows in 0..Rows-1 do
    print("#{row_number}")
    row_number += 1
    for columns in 0..Columns do
      print("\t#{@front_board[rows][columns]}")
    end
    nl()
    nl()
  end
end

def has_digits?(str)
  return str.count("1-9") == 1
end

def has_letters?(str)
  return str.count("A-I") == 1
end

def check_valid_input(square_coordinates)
  if square_coordinates.length > 2
    return false
  end
  return has_digits?(square_coordinates) && has_letters?(square_coordinates)
end

def define_format()
  nl()
  puts("Enter the input in this format: <letter><number> OR <number><letter> for example( 1b or b1 )")
  nl()
  nl()
end

def take_input()
  nl()
  print("Choose a square to select: ")
  nl()
  @square = gets.chomp.upcase
  input_flag = check_valid_input(@square)
  new_square = try_again_input(input_flag)
  select_flag = select_square(new_square)
  while(!select_flag)
    nl()
    print("Choose another square. Try again: ")
    nl()
    @square = gets.chomp.upcase
    input_flag = check_valid_input(@square)
    updated_square = try_again_input(input_flag)
    select_flag = select_square(updated_square)
  end
end

def try_again_input(flag)
  while(!flag)
    print("Invalid input. Try again: ")
    @square = gets.chomp.upcase
    flag = check_valid_input(@square)
  end

  test_square = flip_input(@square)
  return test_square
end

def flip_input(square)
  arr = square.split(//)
  temp = ""
  for i in 0..arr.length()-1 do
    if i == 0 && arr[i].match(/[0-9]/)
      temp = arr[i]
      arr[i] = arr[i+1]
      arr[i+1] = temp
      break
    end
  end
  return arr.join()
end

def select_square(square_coordinates)
  letter_num = Letter_map[square_coordinates[0]]
  if  @front_board[(square_coordinates[1].to_i - 1)][letter_num] != @back_board[(square_coordinates[1].to_i - 1)][letter_num]
    @front_board[(square_coordinates[1].to_i - 1)][letter_num] = @back_board[(square_coordinates[1].to_i - 1)][letter_num]
    if @back_board[(square_coordinates[1].to_i - 1)][letter_num] == "*"
      board_boarders()
      front_board_display()
      nl()
      print("Game Over!")
      nl()
      @gameover = true
    end
    return true
  end
  return false
end

fill_back_board_bomb()
fill_back_board_numbers()
define_format()
while(!@gameover)
  board_boarders()
  front_board_display()
  take_input()
end
