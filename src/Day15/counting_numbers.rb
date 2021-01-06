# Created by Dheeraj Dhall - 12/27/2020

require '../common/file_reader'

class CountingNumbers

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    def create_initial_hash
        nums = @file_data.split(",")

        num_hash = {}

        index = 1
        nums.each do |num|
            num_hash[num.to_i] = index
            index += 1
        end

        num_hash
    end


    def get_2020_number num_hash
        index = num_hash.length
        current_num = 0
        
        while index < 29999999
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
num_hash = cn.create_initial_hash

start = Time.now
puts cn.get_2020_number num_hash
final = Time.now

puts final - start