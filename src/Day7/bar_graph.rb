# Create by Dheeraj Dhall - 12/07/20

require '../common/file_reader'
require 'set'

# This class is an implementation of a graph to find the number of bags
# that are related to a bag
class BarGraph

    def initialize
        @file_data = FileReader.new.get_file_data("input.rtf")
    end

    # This method utilizes a graph of bags to get the number of
    # bags that can carry a shiny gold bag.
    # @args: graph - This is the graph created from the data which
    #               represents the bag and their connections
    #               A bag as key and the bag it can contain as array
    # @args: bag -  The bag whose graph link is required
    # @args: reverse_graph - This is the Adjaceny list reprsentation
    #                         but reversed
    def get_number_of_bags_that_can_hold_bag graph, reverse_graph, bag
        total_count = 0
        queue = Queue.new

        queue.push(bag)

        visited_set = Set.new

        while queue.empty? == false
            len = queue.length
            for i in 1..len
                value = queue.pop
                visited_set.add(value)
                reverse_graph[value].each do |item|
                    
                    if !visited_set.include? item
                        queue.push item 
                    end
                end
                
            end
            total_count += 1
        end
        puts visited_set.length - 1
        total_count + 1
    end 

    # This method creates a graph which follows the adjacency list
    # reprsentation to create a graph
    def create_graph
        rows = @file_data.split("\n")

        graph = Hash.new { |h,k| h[k] = Set.new }
        reverse_graph = Hash.new { |h,k| h[k] = Set.new }
        bag_count_hash = Hash.new { |h,k| h[k] = [] }

        rows.each do |row|
            next if row.include? "no other"
            bag_arr =  row.split(" bags ")
            value_bag = bag_arr[0].strip

            other_bag_data = bag_arr[1].gsub(/[,.]/, "").split(" ")
            
            other_bag_arr = []

            index = 2

            while index < other_bag_data.length
                bag_name = other_bag_data[index].strip + " " + other_bag_data[index + 1].strip
                other_bag_arr.push(bag_name)
                bag_contained_arr = [other_bag_data[index - 1].to_i, bag_name]
                bag_count_hash[value_bag].push(bag_contained_arr)
                index += 4
            end

            other_bag_arr.each do |item|
                reverse_graph[item].add(value_bag)
                graph[value_bag].add(item)
            end
        end
        [graph, reverse_graph, bag_count_hash]
    end

    def get_number_of_bag_that_can_be_carried_within bag, graph, bag_count_hash
        queue = Queue.new
        queue.push(bag)
        total_count = 0
        while queue.empty? == false
            len = queue.length

            while len > 0 
                bag_popped = queue.pop

                bag_count_hash[bag_popped].each do |arr|
                    
                end
            end
        end
    end
end

bg = BarGraph.new
graph_arr = bg.create_graph
# puts bg.get_number_of_bags_that_can_hold_bag graph_arr[0], graph_arr[1], "shiny gold"

puts graph_arr[2]