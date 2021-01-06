# Created by Dheeraj Dhall - 12/27/2020

require '../common/file_reader'

# This class is used to create a sequence of number based on the following requirements
# 1. Given a set of number if the last number appears fist time the next number in the sequence is 0
# 2. If the last number was called out already then the next number is the difference between
#    the current number count and the position of the number when it was called before.
class CountingNumbers

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    # This method is to create an array of the size of the position of the number required
    def create_initial_hash size
        nums = @file_data.split(",")

        num_hash = Array.new(size)
        
        index = 1
        nums.each do |num|
            num_hash[num.to_i] = index
            index += 1
        end

        [num_hash, nums.length]
    end


    # This method gets the number at the position specified
    # @args num_hash:  An array which hold information of the number and the position of the number in sequence
    # @args initial_count: the number of numbers that were initially in the sequence
    # @num_at_pos: The position at which the number needs to be found
    def get_number_at_position num_hash, initial_count, num_at_pos
        index = initial_count
        current_num = 0
        
        while index < num_at_pos - 1
            index += 1
            temp = current_num
            if num_hash[current_num] != nil
                current_num = index - num_hash[current_num]
                num_hash[temp] = index
            else
                current_num = 0
                num_hash[temp] = index
            end                      
        end
        
        current_num
    end
end

cn = CountingNumbers.new
data = cn.create_initial_hash 2020

start = Time.now
puts cn.get_number_at_position data[0], data[1], 2020
final = Time.now

puts final - start