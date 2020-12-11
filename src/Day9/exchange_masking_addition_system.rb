# Created by Dheeraj Dhall = 12/09/21

require '../common/file_reader'
require 'set'

# This class is a an implementation of an addition system referred
# as xmas - ExchangeMaskingAdditionSystem
class ExchangeMaskingAdditionSystem

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    # This method is to find the first number which is invalid in the sequenece
    # A number is invalid if in the previous numbers - preamble count numbers
    # do not have a pair (different digits) that adds to the current number
    # @args: preamble_count : This is the size of the sub array which is checked
    #                         to see, if it contains a pair that adds upto to the 
    #                         number at the next index after the preamble_count
    def get_first_number_not_part_of_xmas preamble_count
        num_arr = @file_data.split("\n")

        num_hash = Hash.new { |h, k| h[k] = Set.new }
        
        left_ptr = 0
        right_ptr = preamble_count

        for i in 0..preamble_count - 1
            value = num_arr[i].to_i
            num_hash[value].add(i)
        end

        while (left_ptr + preamble_count - 1) < num_arr.length && right_ptr < num_arr.length
            target = num_arr[right_ptr].to_i
            
            flag = false
            for i in left_ptr..right_ptr - 1
                current = num_arr[i].to_i
                if num_hash.key?(target - current) && (target - current) != current
                    flag = true
                    break
                end
                num_hash[current].add(left_ptr) if !num_hash[current].include?(left_ptr)
            end

            if flag == false
                return num_arr[right_ptr]
            else
                num_hash[num_arr[right_ptr].to_i].add(right_ptr)
                right_ptr += 1
                num = num_arr[left_ptr].to_i
                num_hash[num].delete(left_ptr)

                if num_hash[num].length == 0
                    num_hash.delete(num)
                end
                left_ptr += 1
            end
        end
    end

    # This method is used to get a subarray in which, when all  numbers are added
    # they match the target provided
    # @args: target: The sum of numbers in the sub-array
    def get_contiguous_set_that_adds_up_to_invalid_number target
        num_arr = @file_data.split("\n")

        total = 0
        left_ptr = 0
        right_ptr = 0

        while right_ptr < num_arr.length
            total += num_arr[right_ptr].to_i
            while total > target.to_i
                total -= num_arr[left_ptr].to_i
                left_ptr += 1
            end
            if total == target.to_i
                break
            end
            right_ptr += 1
        end
        arr = num_arr.slice(left_ptr, (right_ptr.to_i - left_ptr.to_i)).map(&:to_i).sort
        arr[0] + arr[arr.length - 1]
    end
end

xmas = ExchangeMaskingAdditionSystem.new
value =  xmas.get_first_number_not_part_of_xmas 25
puts xmas.get_contiguous_set_that_adds_up_to_invalid_number value