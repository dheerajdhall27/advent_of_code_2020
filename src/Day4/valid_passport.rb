# Create by Dheeraj Dhall - 12/04/2020

# This class is used to check that the passport in the batch file
# is valid

require 'set'
require './passport'

class ValidPassport

    def initialize
        file = File.open("input.rtf")
        @file_data = file.read
        @passport_set = Set["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
    end

    def check_number_of_valid_passports
        passports_data = @file_data.split("\n\n")

        count = 0
        passports_data.each do |pass|
            pass_set = Set.new
            pass_data = pass.split(" ")

            pass_data.each do |data|
                pass_set.add(data.split(":")[0])
            end

            diff_set = @passport_set.difference(pass_set)

            if diff_set.count == 0
                count += 1 
            elsif diff_set.count == 1 && diff_set.include?("cid")
                count += 1
            end
        end
        count
    end
end

vp = ValidPassport.new
puts vp.check_number_of_valid_passports

p = Passport.new
