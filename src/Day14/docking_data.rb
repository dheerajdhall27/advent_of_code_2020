# Created by Dheeraj Dhall - 12/27/2020

require '../common/file_reader'
require 'set'

# This class is used to calculate the sum of values in memory after
# the values have been changed with the provided bit masks
class DockingData

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
        @block_data = @file_data.split("mask")

        @mem_hash = {}
    end

    # This method is to get the some of all the unique values in the memory
    def get_sum_of_values_in_mem
        @block_data.each do |data|
            next if data == ""
            rows = data.split("\n")

            mask = rows[0][3,rows[0].length]
            
            for i in 1..rows.length - 1
                row_data = rows[i].split('] = ')
                mem = row_data[0][4,row_data[0].length].to_i
                value = row_data[1].to_i

                result = get_result_after_mask_is_applied mask, get_bit_str(value)
                
                next if result == nil
                @mem_hash[mem] = result
            end
        end
        sum = 0
        @mem_hash.each do |k, v|
            sum += v
        end
        sum
    end

    # This method is to create a 36 bit string using the decimal povided
    # @args: decimal This is the decimal that needs to be converted to a string
    def get_bit_str decimal
        bit_str = ""
        while decimal != 0
            rem = decimal % 2
            bit_str = rem.to_s + bit_str
            decimal /= 2
        end
        
        for i in 1..36 - bit_str.length
            bit_str = "0" + bit_str            
        end
        bit_str
    end

    # This method provides the decimal value after the mask has been applied
    # @args mask: the bit-mask that needs to be applied
    # @args bit_str: The bit string the bit mak is applied to
    def get_result_after_mask_is_applied mask, bit_str
        result_str = ""

        index = bit_str.length - 1

        while index >= 0
            if mask[index] == 'X' 
                result_str = bit_str[index] + result_str
            else
                result_str = mask[index] + result_str
            end
            index -= 1
        end
        
        bit_str != result_str ? result_str.to_i(2) : nil
    end


    def get_sum_of_values_in_mem_2
        @block_data.each do |data|
            next if data == ""
            rows = data.split("\n")

            mask = rows[0][3,rows[0].length]
            
            for i in 1..rows.length - 1
                row_data = rows[i].split('] = ')
                mem = row_data[0][4,row_data[0].length].to_i
                value = row_data[1].to_i

                result = get_result_after_mask_is_applied_2 mask, get_bit_str(value)

                
            end
        end
        sum = 0
        @mem_hash.each do |k, v|
            sum += v
        end
        sum
    end
    
    def get_result_after_mask_is_applied_2 mask, bit_str
        result_str = ""

        index = bit_str.length - 1
        floating_count = 0
        floating_arr = []

        while index >= 0
            if mask[index] == 'X' 
                result_str = 'X' + result_str
                floating_count += 1
                floating_arr.push(index)
            elsif mask[index] == '0'
                result_str = bit_str[index] + result_str
            else
                result_str = '1' + result_str
            end
            index -= 1
        end
        
        result_str, floating_count, floating_arr
    end
end

dd = DockingData.new
# puts dd.get_sum_of_values_in_mem
# puts dd.get_bit_str 43619