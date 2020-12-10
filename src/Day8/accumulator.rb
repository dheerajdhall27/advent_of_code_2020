# Created by Dheeraj Dhall - 12/08/2020

require '../common/file_reader'
require 'set'

# This is an implementation of an accumulator that works based on commands
# TODO: Improve documentation and remove redundancy
class Accumulator

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    # This method is used to get the value on the accumulator
    # before the second iteration begins
    def get_value_on_accumulator_before_second_iteration
        row_data = @file_data.split("\n")
        # A set to keep track of visited indexes
        index_set = Set.new

        current_index = 0
        accumulator = 0
        while !index_set.include? current_index || current_index < row_data.length
            index_set.add(current_index)

            operation, value = row_data[current_index].split(" ")

            case operation
            when "nop"
                current_index += 1
            when "acc"
                accumulator += value.to_i
                current_index += 1
            when "jmp"
                current_index += value.to_i
            else
                "Error: Invalid value passed"
            end
            return accumulator if index_set.include? current_index
        end

        accumulator
    end

    # This method fixes the infinite loop by changing either the jump operation to nop
    # or vice-versa
    def get_accumulator_value_by_fixing_infinite_loop
        row_data = @file_data.split("\n")

        index_set = Set.new

        current_index = 0
        accumulator = 0


        while current_index < row_data.length
            operation, value = row_data[current_index].split(" ")

            case operation
            when "nop"
                is_infinite = check_if_ends_in_infinite_loop? index_set.dup, current_index, row_data, "jmp", value, accumulator
                if is_infinite[0] == false
                    return is_infinite[1]
                end
                current_index += 1
            when "acc"
                accumulator += value.to_i
                current_index += 1
            when "jmp"
                is_infinite = check_if_ends_in_infinite_loop? index_set.dup, current_index, row_data, "nop", value, accumulator
                if is_infinite[0] == false
                    return is_infinite[1]
                end
                current_index += value.to_i
            else
                "Error: Invalid value passed"
            end
        end
    end

    private 

    def check_if_ends_in_infinite_loop? index_set, current_index, row_data, operation, value, accumulator
        index_set.add(current_index)
        if operation == "jmp"
            current_index += value.to_i
        else
            current_index += 1
        end

        while current_index < row_data.length
            index_set.add(current_index)

            operation, value = row_data[current_index].split(" ")
            case operation
            when "nop"
                current_index += 1
            when "acc"
                accumulator += value.to_i
                current_index += 1
            when "jmp"
                current_index += value.to_i
            else
                "Error: Invalid value passed"
            end
            return [true] if index_set.include? current_index
        end

        [false, accumulator]
    end
end

acc = Accumulator.new
# puts acc.get_value_on_accumulator_before_second_iteration
puts acc.get_accumulator_value_by_fixing_infinite_loop