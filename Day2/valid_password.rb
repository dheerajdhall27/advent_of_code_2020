# Created by Dheeraj Dhall - 12/2/2020

class ValidPassword

    attr_accessor :file_data

    def initialize
        file = File.open("input.rtf")
        @file_data = file.read.split("\n")
    end

    # This method is used to get the valid passwords  from a given file
    # A password is valid if the instances of a particular character is between the range provided
    # Example: 
    # 1-3 a: abcde
    # 1-3 b: cdefg
    # 2-9 c: ccccccccc
    # There are two valid passwords as the second entry doesny have a 'b'
    def get_number_of_valid_passwords
        valid_passwords = 0
        @file_data.each do |data|
            row = data.split(" ")

            # This part is to get the min and max occurences of the character
            instances = row[0].split("-")
            char_to_test = row[1].chomp(":")
            pass = row[2]

            count =  pass.count(char_to_test)
            
            valid_passwords += 1 if count >= instances[0].to_i and count <= instances[1].to_i
        end
        valid_passwords
    end


    def get_number_of_valid_passwrods_based_on_position
        valid_passwords = 0
        @file_data.each do |data|
            row = data.split(" ")

            # This part is to get the min and max occurences of the character
            instances = row[0].split("-")
            char_to_test = row[1].chomp(":")
            pass_char_array = row[2].split("")

            if pass_char_array[instances[0].to_i - 1] == char_to_test and
               pass_char_array[instances[1].to_i - 1] != char_to_test
                valid_passwords += 1
            elsif pass_char_array[instances[0].to_i - 1] != char_to_test and
                  pass_char_array[instances[1].to_i - 1] == char_to_test
                  valid_passwords += 1
            end
        end
        valid_passwords
    end
end


vp = ValidPassword.new
puts vp.get_number_of_valid_passwords
puts vp.get_number_of_valid_passwrods_based_on_position