# Created by Dheeraj Dhall - 12/2/2020


# This class represents the the 1st problem from Advent of Code 2020
# The implementation is used to get the 2sum and 3sum with the target set as 2020
class ExpenseReport

    attr_accessor :file_data

    # This is the ExpenseReport Constructor
    # It is used to get the file data
    def initialize
        file = File.open("input.rtf")
        @file_data = file.read.split("\n")
    end

    # This method is used to return the product of two numbers that sum to 2020
    # This is similar to the two sum problem
    def get_two_numbers_product
        number_dictionary = {}
        @file_data.each do |num|
            if number_dictionary[2020 - num.to_i]
                return num.to_i * (2020 - num.to_i)
            else
                number_dictionary[num.to_i] = num.to_i
            end
        end
        nil
    end

    # This method is used to return the product of three numbers that sum to 2020
    # This is similar to the three sum problem
    def get_three_numbers_product
        number_dictionary = {}
        @file_data.each do |num|
            number_dictionary[num.to_i] = num.to_i
        end
        
        for i in 0..@file_data.length
            for j in i + 1..@file_data.length
                sum = @file_data[i].to_i + @file_data[j].to_i 
                if number_dictionary[2020 - sum]
                    val = number_dictionary[2020 - sum]
                    return val * @file_data[i].to_i * @file_data[j].to_i
                end
            end
        end
    end 
end

er = ExpenseReport.new
puts er.get_two_numbers_product
puts er.get_three_numbers_product