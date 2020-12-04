# Created by Dheeraj Dhall - 12/2/2020


# This class is to draw out a path in a 2D array
# starting from the top left.
class Path

    def initialize
        file = File.open("input.rtf")
        @file_data = file.read         
        @tree = "#"   
    end

    # This method is used to get the number of trees encountered on the path taken
    # The path starts from the top left and ends when the bottom-row is reached
    # The path follow this pattern
    #     1. Move 3 towards right and 1 down
    #     2. Continue step 1 till the bottom row is reached
    # @args map: This method takes in a 2-D map that is used to get the count of the trees
    # @args right: This is the amount to move right
    # @args down: This is the amount to move down
    def get_number_of_trees map, right, down
        row_index = 0
        col_index = 0
        tree_count = 0
        
        while row_index < map.length - 1
            col_index = (col_index + right) % map[row_index].length
            row_index += down    
            tree_count += 1 if map[row_index][col_index] == @tree
        end
        tree_count
    end

    # This method is used to create a 2-D map
    # Map has two values
    #     1. (.) that represents an open square.
    #     2. (#) that represents a tree.
    def create_map
        # This is going to be a 2-D map
        map = []
        
        rows_arr = @file_data.split("\n")

        rows_arr.each do |row|
            arr = row.split("")

            map.push(arr)
        end
        map
    end

end

p = Path.new
map = p.create_map
right = 1
down = 2
puts p.get_number_of_trees map, right, down


# Slope values
# Right 1, down 1 -  85
# Right 3, down 1 - 272
# Right 5, down 1 -  66
# Right 7, down 1 -  73
# Right 1, down 2 -  35
