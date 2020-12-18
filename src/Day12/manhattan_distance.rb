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

# This class is to find the manhattan distance between the x and y co-ordinate
class ManhattanDistance

    include Direction

    def initialize
        @rows = FileReader.new.get_file_data("input.rtf").split("\n")
        
        @ship_world_orientation = {"x" => EAST, "y" => NORTH}
        @ship_orientation = EAST

        @ship_angle = 0

        @x_distance = 0
        @y_distance = 0

        @waypoint = {"x" => 10, "y" => 1}
        @waypoint_orientation = {"x" => EAST, "y" => NORTH}
        @waypoint_angle = 0

        @ship_orientation_data = {
            0 => EAST,
            180 => WEST,
            270 => NORTH,
            90 => SOUTH
        }

        @waypoint_orientation_data = {
            0 => [EAST, NORTH],
            90 => [EAST, SOUTH],
            180 => [WEST, SOUTH],
            270 => [WEST, NORTH]
        }
    end

    def map_out_the_route_and_get_lat_long_data

        @rows.each do |dir|
            amount = dir[1..dir.length - 1].to_i
            # update_direction_and_position dir[0], amount
            update_direction_and_position_based_on_waypoint dir[0], amount
            puts @x_distance.to_s + "::" + @y_distance.to_s
            puts @waypoint_orientation
            puts "++++++++++++++++++++++++++++++"
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
                
            @ship_orientation = @ship_orientation_data[@ship_angle]
        when FORWARD
            update_direction_and_position @ship_orientation, amount
        end
    end

    def update_direction_and_position_based_on_waypoint dir, amount
        case dir
        when EAST
            @waypoint["x"] += amount
        when WEST
            @waypoint["x"] -= amount
        when NORTH
            @waypoint["y"] += amount
        when SOUTH
            @waypoint["y"] -= amount
        when LEFT, RIGHT
            @waypoint_angle = dir == LEFT ? @waypoint_angle - amount : @waypoint_angle + amount
            @waypoint_angle = @waypoint_angle % 360

            orientation_data = @waypoint_orientation_data[@waypoint_angle]
            if (@waypoint_orientation["x"] == orientation_data[0] and 
                @waypoint_orientation["y"] != orientation_data[1]) or
                (@waypoint_orientation["x"] != orientation_data[0] and
                @waypoint_orientation["y"] == orientation_data[1])
                x_value = @waypoint["x"]
                y_value = @waypoint["y"]

                @waypoint["x"] = y_value
                @waypoint["y"] = x_value
            end
            @waypoint_orientation["x"] = orientation_data[0]
            @waypoint_orientation["y"] = orientation_data[1]
        when FORWARD
            x_value = @waypoint["x"] * amount
            y_value = @waypoint["y"] * amount
            puts x_value.to_s + "::" + y_value.to_s
            update_direction_and_position @waypoint_orientation["x"], x_value
            update_direction_and_position @waypoint_orientation["y"], y_value
        end
    end

    def get_manhattan_distance start, last
        start.abs + last.abs
    end
end


md = ManhattanDistance.new
data = md.map_out_the_route_and_get_lat_long_data
puts md.get_manhattan_distance data[0], data[1]