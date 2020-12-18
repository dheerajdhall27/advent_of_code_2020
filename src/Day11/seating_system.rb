# Created by Dheeraj Dhall - 12/13/2020

require '../common/file_reader'

# This class is an implementation of the seating system
# A seat can be in 2 states
# 1. L - Empty 2. # - occupied
# There is a third state but for a position in the row
# It is (.) which refers to floor
# TODO: Fix the redundancy in code
class SeatingSystem

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    # This method is used to get the number of occupied seats after running through the rules
    # of occupying a seat
    def get_num_of_occupied_seats_after_no_change
        rows = @file_data.split("\n")
        changed_flag = 1

        while changed_flag != 0
            changed_flag = 0
            rows_dup = Marshal.load(Marshal.dump(rows))
            for i in 0..rows.length - 1
                for j in 0..rows[0].length - 1
                    next if rows[i][j] == "."
                    count = get_number_of_neighbours_occupied rows, i, j
                    if rows[i][j] == "L" and count == 0
                        rows_dup[i][j] = "#"
                        changed_flag = 1
                    elsif rows[i][j] == "#" and count >= 4
                        rows_dup[i][j] = "L"
                        changed_flag = 1
                    end
                end
            end
            rows = Marshal.load(Marshal.dump(rows_dup))
        end
        
        puts get_number_of_occupied_seats rows
    end

    # This method is to count the number of occupied seats in all rows
    # @args rows: All the seats that are currently being checked
    def get_number_of_occupied_seats rows
        count = 0
        for i in 0..rows.length - 1
            for j in 0..rows[i].length - 1
                if rows[i][j] == "#"
                    count += 1
                end
            end
        end

        count
    end

    # This method is used to check all the neighbors
    # There are 8 neighbors at the most.
    # The neighbors are in the direction
    # [-1,-1], # NW
    # [-1,0],  # N
    # [-1,1],  # NE
    # [0, 1],  # E
    # [1, 1],  # SE
    # [1, 0],  # S
    # [1,-1],  # SW
    # [0,-1],  # W
    #
    # @args rows: all the rows that have seats in them
    # @args  row: a particular row index
    # @args  col: a particular col index
    def get_number_of_neighbours_occupied rows, row, col
        count = 0
        for i in -1..1
            next if (row + i) >= rows.length or (row + i) < 0
            for j in -1..1
                next if (col + j) >= rows[row].length or (col + j) < 0
                next if (row + i) == row and (col + j) == col
                if rows[row + i][col + j] == "#"
                    count += 1
                end
            end
        end

        count
    end


    # This method is to calculate the number of seats that are occupied after there is
    # no change made to any row.
    def get_number_of_seats_with_visibility_after_no_change
        rows = @file_data.split("\n")
        changed_flag = 1
        while changed_flag != 0
            changed_flag = 0
            rows_dup = Marshal.load(Marshal.dump(rows))

            for i in 0..rows.length - 1
                for j in 0..rows[0].length - 1
                    next if rows[i][j] == "."
                    count = get_number_of_neighbours_visible_that_are_occupied rows, i, j
                    if rows[i][j] == "L" and count == 0
                        rows_dup[i][j] = "#"
                        changed_flag = 1
                    elsif rows[i][j] == "#" and count >= 5
                        rows_dup[i][j] = "L"
                        changed_flag = 1
                    end
                end
            end
            rows = Marshal.load(Marshal.dump(rows_dup))
        end

        puts get_number_of_occupied_seats rows
    end

    # This method is to get the number of occupied seats from a given point by looking in all direction
    # This method looks for neighbors that are visible - First L or # found in the direction
    # The search is not limited to immediate neighbors
    # @args rows: All the rows that have seats - which are occupied, empty or just floor
    # @args  row: a particular row index
    # @args  col: a particular col index
    def get_number_of_neighbours_visible_that_are_occupied rows, row, col
        count = 0

        directions = [[-1,-1], # NW
                      [-1,0],  # N
                      [-1,1],  # NE
                      [0, 1],  # E
                      [1, 1],  # SE
                      [1, 0],  # S
                      [1,-1],  # SW
                      [0,-1],  # W
                    ]


        directions.each do |dir|
            current_row = row + dir[0]
            current_col = col + dir[1]

            while true

                break if current_row < 0 or current_row > rows.length - 1
                break if current_col < 0 or current_col > rows[row].length - 1

                if rows[current_row][current_col] == "#"
                    count += 1
                    break
                elsif rows[current_row][current_col] == "L"
                    break
                else
                    current_row += dir[0]
                    current_col += dir[1]    
                end
            end
        end

        count
    end
end

start = Time.now
ss = SeatingSystem.new
ss.get_num_of_occupied_seats_after_no_change
ss.get_number_of_seats_with_visibility_after_no_change

finish = Time.now
puts "Time Taken: " + (finish - start).to_s + " Seconds"
