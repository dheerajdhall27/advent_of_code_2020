# Created by Dheeraj Dhall - 01/6/2020

require '../common/file_reader'
require 'set'

class TicketTranslation

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
        
        @description_hash = {}
        @ticket_arr = []
        @tickets_arr = []

        @invalid_arrays = []

        @type_and_index_hash = {}
    end

    def create_hashes
        blocks = @file_data.split("\n\n")

        # Create the description and range hash
        blocks[0].split("\n").map do |line|
            type = line.split(":")[0].to_s
            arr = line.split(/(\d+)-(\d+) or (\d+)-(\d+)/)
            @description_hash[type] = arr[1, arr.length - 1].map(&:to_i)
        end

        # Create your ticket
        @ticket_arr = blocks[1].split("\n")[1].split(",").map(&:to_i)
        
        # Create arr for the nearby tickets
        blocks[2].split(":\n")[1].split("\n").each do |line|            
            @tickets_arr.push(line.split(",").map(&:to_i))
        end
    end

    def get_sum_of_invalid_numbers_from_rows
        invalid_numbers = []
        
        index = 0
        length = 0
        @tickets_arr.each do |arr|
            arr.each do |num|
                count = 0
                @description_hash.each do |type, arr|
                    if num >= arr[0] &&  num <= arr[1] ||
                       num >= arr[2] && num <= arr[3]
                       count = 1
                       break
                    end
                end

                invalid_numbers.push(num) if count == 0
            end

            if invalid_numbers.length != length 
                @invalid_arrays.push(index)
                length = invalid_numbers.length
            end
            index += 1
        end
        invalid_numbers.reduce(0) {|sum, num| sum + num}
    end

    def create_correct_order_of_ticket_values
        final_set_arr = get_all_types_a_num_can_be_under
        
        @type_and_index_hash[final_set_arr[0][0]] = final_set_arr[0][1]
        for i in 1..final_set_arr.length - 1
            type = (final_set_arr[i][0] - final_set_arr[i - 1][0]).to_a[0]
            @type_and_index_hash[type] = final_set_arr[i][1]
        end 
    end

    def get_types_which_contain str
        @type_and_index_hash.select {|type, index| type.include? str}
    end

    def get_product_of_values_from_original_ticket types_with_departure
        values = []

        types_with_departure.each do |type, index|
            values.push(@ticket_arr[index].to_i)
        end

        values.inject(:*)
    end

    def get_all_types_a_num_can_be_under
        correct_order_hash = {}

        final_set_arr = []
        for i in 0..@ticket_arr.length - 1
            previousSet = Set.new

            @description_hash.each do |type, arr|
                if @tickets_arr[0][i] >= arr[0] && @tickets_arr[0][i] <= arr[1] ||
                    @tickets_arr[0][i] >= arr[2] && @tickets_arr[0][i] <= arr[3]
                    previousSet.add(type)
                end
            end
            for j in 1..@tickets_arr.length - 1
                next if @invalid_arrays.include? j

                set = Set.new
                num = @tickets_arr[j][i]                
                @description_hash.each do |type, arr|
                    if num >= arr[0] && num <= arr[1] ||
                       num >= arr[2] && num <= arr[3]
                        set.add(type)
                    end
                end
                previousSet = previousSet & set
            end
            
            final_set_arr.push([previousSet, i])
        end

        final_set_arr.sort_by {|arr,index| arr.length}
    end
end

tt = TicketTranslation.new
tt.create_hashes

tt.get_sum_of_invalid_numbers_from_rows
tt.create_correct_order_of_ticket_values
types_with_departure = tt.get_types_which_contain "departure"

puts tt.get_product_of_values_from_original_ticket types_with_departure

