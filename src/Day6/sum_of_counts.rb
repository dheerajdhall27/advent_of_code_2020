# Create by Dheeraj Dhall - 12/06/2020

require '../common/file_reader'
require 'set'

# This class represents the implementation of finding the count of people that answered yes to a questionnaire
class SumOfCounts

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
        @starting_ascii = 97
    end

    # This method gets the total count of the people that said yes
    # This works on the keyword "anyone". If anyone said yes they are added to the count
    # The idea of saying yes is that the character is included in the group - does not count duplicates
    # For Example:
    # 
    # 1. abc
    # Here one person said yes to three questions
    # 
    # 2.ab
    #   ac
    # Here the first person said yes to questions a and b
    # Second person said yes to questions a and c
    def get_sum_where_anyone_answered_yes
        # Get all the groups
        groups = @file_data.split("\n\n")

        total_count = 0

        groups.each do |group|
           # replace the new line in a group to form a long string
           group = group.gsub("\n", "")

           # Following the idea of SIEVE OF ERATOSTHENES
           # All bits are 0 (nil in this case)
           # They are flipped to 1 if the char exists
           char_ascii_flag_arr = Array.new(26)

           group.each_byte do |c|
            char_ascii_flag_arr[c.to_i - @starting_ascii] = 1
           end
           
           char_ascii_flag_arr.each do |cafa_item|
            total_count += 1 if cafa_item == 1
           end
        end
        total_count
    end

    # This method gets the total count of the people in a group that said yes to same questions
    # This works on the keyword "everyone".
    # The count is incremented when everyone in the group answers yes to a particular question
    # For Example:
    # 
    # 1. abc
    # In the first group, everyone (all 1 person) answered "yes" to 3 questions: a, b, and c.
    # 
    # 2.ab
    #   ac
    # In the third group, everyone answered yes to only 1 question, a. Since some people did not
    # answer "yes" to b or c, they don't count.
    def get_sum_where_everyone_answered_yes
        # Get all the groups
        groups = @file_data.split("\n\n")

        total_count = 0
        
        groups.each do |group|
            person_arr = group.split("\n")
            first_set = person_arr[0].split("").to_set
            count = first_set.length

            for i in 1..person_arr.length - 1
                set_to_compare = person_arr[i].split("").to_set
                
                first_set = first_set.intersection(set_to_compare)

                break if first_set.length == 0
            end
            total_count += first_set.length
        end

        total_count
    end
end

sc = SumOfCounts.new
# puts sc.get_sum_where_anyone_answered_yes
puts sc.get_sum_where_everyone_answered_yes