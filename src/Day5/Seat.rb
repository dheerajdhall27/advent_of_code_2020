# Created by Dheeraj Dhall - 12/05/2020


# This class represents the Seat on an airplane
# which is calculated from string that uses binary space partitioning
class Seat


    def initialize
        file = File.open("input.rtf")
        @file_data = file.read
        @all_seats = []
    end

    # This method is used to get the max seat ID on the airplane
    # It also adds all the seat IDs to an array which can be later utilized
    def get_max_seat_id
        bin_str_arr = @file_data.split("\n")

        max = 0
        bin_str_arr.each do |str|
            row = get_row_or_col_number str[0..6], 0, 127
            col = get_row_or_col_number str[7..9], 0, 7
            
            value = row * 8 + col
            @all_seats.push(value)
            max = value > max ? value : max
        end
        max
    end

    # This method is usd to get the row number or the col number on the plane
    # It uses binary space partition and the current characters are 
    # F - First Half : B - Second half
    # and similary
    # L - First Half : R - Second half
    def get_row_or_col_number str, first, last
        current_index = 0
        row_or_col_num = 0

        while current_index < str.length - 1
            mid = (first + last).to_f / 2
            
            if str[current_index] == "F" || str[current_index] == "L"
                last = mid.floor
            else
                first = mid.ceil
            end
            current_index += 1
        end

        if str[current_index] == "F" || str[current_index] == "L"
            row_or_col_num = first
        else
            row_or_col_num = last
        end
        row_or_col_num
    end

    # This method is used to get the missing seat
    # Since the seat are on a plane they are in an order
    # Sorting the seats and looking for the seat that is missing in the range gives the answer
    def get_missing_seat
        @all_seats = @all_seats.sort

        for i in 1..@all_seats.length - 1
            if @all_seats[i] - @all_seats[i - 1] != 1
                return @all_seats[i - 1] + 1
            end
        end
        return nil
    end
end

s = Seat.new
puts s.get_max_seat_id
puts s.get_missing_seat

