# Created by Dheeraj Dhall - 12/10/2020

require '../common/file_reader'
require 'set'

# This class is an implementation to connect adapter of varied jolts
class JoltDifference

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    # This method is used to get the numtiplication of 
    # 1-jolt difference and 3-jolt difference
    def get_mul_of_one_jolt_and_three_jolt_diff
        num_arr = @file_data.split("\n").map(&:to_i).sort

        built_in_joltage = num_arr[num_arr.length - 1] + 3
        num_arr.push(built_in_joltage)

        jolt_diff_hash = {}

        current_joltage = 0
        for i in 0..num_arr.length - 1
            value = num_arr[i] - current_joltage

            if jolt_diff_hash.key?(value)
                jolt_diff_hash[value] += 1
            else
                jolt_diff_hash[value] = 1
            end
            current_joltage = num_arr[i]
        end

        jolt_diff_hash[1] * jolt_diff_hash[3]
    end


    # This method gives the total number of ways adapters can be connected
    def get_number_of_ways_to_connect_adapter tree, value, hash, sum
        return 1 if tree[value].length == 0
        return hash[value] if !hash[value].nil?

        tree[value].each do |item|
            sum += get_number_of_ways_to_connect_adapter tree, item, hash, sum
            hash[value] = sum
        end

        sum
    end

    # This method is used to create an adjaceny list representation
    # of the adapters provided
    # An adapter can be connected - be a part of a list 
    # if the jolt difference them is 3
    def create_tree
        num_arr = @file_data.split("\n").map(&:to_i).sort

        built_in_joltage = num_arr[num_arr.length - 1] + 3
        num_arr.push(built_in_joltage)
        num_arr.unshift(0)

        tree_hash = Hash.new { |h, k| h[k] = [] }

        for i in 0..num_arr.length - 1
            flag = false
            while flag == false
                for j in (i + 1)..num_arr.length - 1
                    if num_arr[j] - num_arr[i] <= 3
                        tree_hash[num_arr[i]].push(num_arr[j])
                    else
                        flag = true
                        break
                    end
                end
                flag = true
            end
        end

        tree_hash
    end
end

jd = JoltDifference.new
# puts jd.get_mul_of_one_jolt_and_three_jolt_diff
tree = jd.create_tree

puts jd.get_number_of_ways_to_connect_adapter tree, 0, {}, 0