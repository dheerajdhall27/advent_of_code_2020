# Create by Dheeraj Dhall - 12/05/2020

# This class is to implement the File reading functionality for 
# the AdventOfCode questions
class FileReader

    def get_file_data file_name
        file = File.open(file_name)
        file.read
    end
end