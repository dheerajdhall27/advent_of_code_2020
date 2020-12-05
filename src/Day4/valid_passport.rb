# Create by Dheeraj Dhall - 12/04/2020

# This class is used to check that the passport in the batch file
# is valid

require 'set'

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

    def get_number_of_valid_passports_with_validation
        passports_data = @file_data.split("\n\n")

        count = 0
        passports_data.each do |pass|
            pass_set = Set.new
            pass_data = pass.split(" ")

            pass_hash = {}
            pass_data.each do |data|
                pass_set.add(data.split(":")[0])
                pass_hash[data.split(":")[0]] = data.split(":")[1]
            end

            diff_set = @passport_set.difference(pass_set)

            if diff_set.count == 0 || diff_set.count == 1 && diff_set.include?("cid")
                value = validate_fields? pass_hash
                count += 1 if value == true
            end
        end
        count
    end


    def validate_fields? pass_hash
        v = validate_birth_year? pass_hash["byr"]
        v1 = validate_issue_year? pass_hash["iyr"]
        v2 = validate_expiration_year? pass_hash["eyr"]
        v3 = validate_height? pass_hash["hgt"]
        v4 = validate_hair_color? pass_hash["hcl"]
        v5 = validate_eye_color? pass_hash["ecl"]
        v6 = validate_passport_id? pass_hash["pid"]

        return false if v == false || v1 == false || v2 == false || v3 == false || v4 == false || v5 == false || v6 == false

        true
    end

    def validate_birth_year? byr
        return false if byr.length > 4

        value = byr.to_i
        value >= 1920 and value <= 2002
    end

    def validate_issue_year? iyr
        return false if iyr.length > 4

        value = iyr.to_i
        value >= 2010 and value <= 2020
    end

    def validate_expiration_year? eyr
        return false if eyr.length > 4

        value = eyr.to_i
        value >= 2020 and value <= 2030
    end

    def validate_height? hgt
        return false if hgt.match(/^[0-9]{3}cm$/) == nil and hgt.match(/^[0-9]{2}in$/) == nil

        if hgt.include? 'cm'
            value = hgt.chomp('cm').to_i
            return false if value < 150 or value > 193
        else 
            value = hgt.chomp('in').to_i
            return false if value < 59 or value > 76
        end
        true
    end

    def validate_hair_color? hcl
        return false if hcl.match(/^#[0-9a-f]{6}$/) == nil

        true
    end

    def validate_eye_color? ecl
        arr = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include? ecl
    end

    def validate_passport_id? pid
        pid.match(/^[0-9]{9}$/) != nil
    end
end

vp = ValidPassport.new
# puts vp.check_number_of_valid_passports
puts vp.get_number_of_valid_passports_with_validation