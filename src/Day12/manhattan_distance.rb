# Created by Dheeraj Dhall - 12/15/2020

require '../common/file_reader'

module Direction
    EAST    = "E"
    WEST    = "W"
    NORTH   = "N"
    SOUTH   = "S"
    LEFT    = "L"
    RIGHT   = "R"
    FORWARD = "F"
end


class ManhattanDistance

    include Direction

    def initialize
        @rows = FileReader.new.get_file_data("input.rtf").split("\n")
        
        @ship_current_orientation = {"x" => EAST, "y" => NORTH}
        @ship_world_orientation = {"x" => EAST, "y" => NORTH}
        @ship_orientation = EAST

        @ship_angle = 0

        @x_distance = 0
        @y_distance = 0

        @ship_orientation_data = {
            0 => EAST,
            180 => WEST,
            270 => NORTH,
            90 => SOUTH
        }
    end

    def map_out_the_route_and_get_lat_long_data

        @rows.each do |dir|
            amount = dir[1..dir.length - 1].to_i
            update_direction_and_position dir[0], amount
        end
        [@x_distance, @y_distance]
    end

    def update_direction_and_position dir, amount
        case dir
        when EAST
            @x_distance += amount
        when WEST
            @x_distance -= amount
        when NORTH
            @y_distance += amount
        when SOUTH
            @y_distance -= amount
        when LEFT, RIGHT
            @ship_angle = dir == LEFT ? @ship_angle - amount : @ship_angle + amount
            @ship_angle = @ship_angle % 360
                
            direction = @ship_orientation_data[@ship_angle]
            @ship_orientation = direction
        when FORWARD
            update_direction_and_position @ship_orientation, amount
        end
    end

    def get_manhattan_distance start, last
        start.abs + last.abs
    end
end


md = ManhattanDistance.new
data = md.map_out_the_route_and_get_lat_long_data
puts md.get_manhattan_distance data[0], data[1]