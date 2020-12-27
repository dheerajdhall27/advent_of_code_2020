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

# This class is to find the manhattan distance between the x and y co-ordinates
# The distance calculated is the absolute distance
class ManhattanDistance

    include Direction

    def initialize
        @rows = FileReader.new.get_file_data("input.rtf").split("\n")
        
        @ship_world_orientation = {"x" => EAST, "y" => NORTH}
        @ship_orientation = EAST

        @ship_angle = 0

        @ship_orientation_data = {
            0 => EAST,
            180 => WEST,
            270 => NORTH,
            90 => SOUTH
        }

        @x_distance = 0
        @y_distance = 0

        @waypoint = {"x" => 10, "y" => 1}
    end

    # This method is used to get the final x,y coords of the ship
    # It takes a function as an argument
    # @args: the function can be position based on waypoint or just the direction
    def map_out_the_route_and_get_x_y_coord func

        @rows.each do |dir|
            amount = dir[1..dir.length - 1].to_i
            method(func).call dir[0], amount
        end
        [@x_distance, @y_distance]
    end

    # This method is used to update the ship's direction and position
    # @args: dir the command that needs to be executed N E W S L R F
    # The amount that direction of angle needs to be adjusted by
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

    # This method is used to update the ship's position based on the waypoint
    # This method also updates the waypoint
    # @args: dir the command that needs to be executed N E W S L R F
    # The amount that direction of angle needs to be adjusted by
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
        when LEFT
            for i in 1..amount/90
                x_value = @waypoint["y"] * - 1
                y_value = @waypoint["x"]

                @waypoint["x"] = x_value
                @waypoint["y"] = y_value
            end
        when RIGHT
            for i in 1..amount/90
                x_value = @waypoint["y"]
                y_value = @waypoint["x"] * -1

                @waypoint["x"] = x_value
                @waypoint["y"] = y_value
            end
        when FORWARD
            x_value = @waypoint["x"] * amount
            y_value = @waypoint["y"] * amount
            
            @x_distance += x_value
            @y_distance += y_value
        end
    end

    def get_manhattan_distance start, last
        start.abs + last.abs
    end
end


md = ManhattanDistance.new

data = md.map_out_the_route_and_get_x_y_coord(:update_direction_and_position)
puts md.get_manhattan_distance data[0], data[1]

md1 = ManhattanDistance.new
data1 = md1.map_out_the_route_and_get_x_y_coord(:update_direction_and_position_based_on_waypoint)

puts md1.get_manhattan_distance data1[0], data1[1]