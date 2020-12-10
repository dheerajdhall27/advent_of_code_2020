# Created by Dheeraj Dhall = 12/09/21

require '../common/file_reader'
require 'set'

# This class is a representa
class ExchangeMaskingAdditionSystem

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    def get_first_number_not_part_of_xmas preamble_count
        num_arr = @file_data.split("\n")

        num_hash = Hash.new { |h, k| h[k] = [] }
        

        for i in 0..preamble_count - 1
            num_ser.add()
        end

    end
end