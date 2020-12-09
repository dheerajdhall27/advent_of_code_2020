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
    # @args: reverse_graph - This is the Adjaceny list reprsentation
    #                        but reversed.
    #                        For Example: 
    #                        1. drab chartreuse bags contain 1 shiny white bag.
    #                           Here the key would be "shiny white" and the value 
    #                           is drab chartreuse
    #
    #                        2. faded coral bags contain 4 dotted green bags, 2 dim violet bags, 3 striped magenta bags.
    #                           Here there are 3 keys.
    #                           1. dotted green 
    #                           2. dim violet 
    #                           3. striped magenta
    #
    #                        The mapping is from right to left and not left to right.
    #
    # @args: bag -  The bag whose graph link is required
    # The idea is to use Breadth First Search and find unique bags that are parents and grandparents and so on..
    def get_number_of_bags_that_can_hold_bag reverse_graph, bag
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
        end
        # We deduct 1 as we added the passed bag as well 
        # 
        visited_set.length - 1
    end 

    # This method perform three main operations
    # 1. Create a graph - using adjacency list representation
    # 2. Create a graph which in inverse of the graph from step 1
    # 3. Create a hash which holds information of 
    #    i. Number of bags that can be contained in the key bag
    #   ii. The bag types
    def create_graph
        rows = @file_data.split("\n")

        graph = Hash.new { |h,k| h[k] = Set.new }
        reverse_graph = Hash.new { |h,k| h[k] = Set.new }
        bag_count_hash = Hash.new { |h,k| h[k] = [] }

        rows.each do |row|
            next if row.include? "no other"
            bag_arr =  row.split(" bags ")
            value_bag = bag_arr[0].strip

            inner_bag_data = bag_arr[1].gsub(/[,.]/, "").split(" ")
            
            inner_bag_arr = []

            index = 2
            bag_count = 0

            while index < inner_bag_data.length
                bag_name = inner_bag_data[index].strip + " " + inner_bag_data[index + 1].strip
                inner_bag_arr.push(bag_name)
                
                individual_inner_bag_arr = [inner_bag_data[index - 1].to_i, bag_name]

                bag_count_hash[value_bag].push(individual_inner_bag_arr)

                bag_count += inner_bag_data[index - 1].to_i
                index += 4
            end

            bag_count_hash[value_bag].push(bag_count)

            inner_bag_arr.each do |item|
                reverse_graph[item].add(value_bag)
                graph[value_bag].add(item)
            end
        end
        [graph, reverse_graph, bag_count_hash]
    end

    # This method get the count of the bags that can be carried 
    # in the given bag
    # @args: bag - The bag which has other bags and this is used to determine the count
    # @args: graph - The graph of bags that was created from the data represented using
    #                adjacency list
    # @ args: bag_count_hash: Hash Which holds information of the number of bags a bag can hold
    def get_number_of_bag_that_can_be_carried_within bag, graph, bag_count_hash
        queue = Queue.new
        queue.push(bag)
        total_count = 0

        visited_set = Set.new
        while queue.empty? == false
            len = queue.length

            while len > 0 
                bag_popped = queue.pop
                arr = bag_count_hash[bag_popped]
                arr.each do |item|
                    item[0].times { queue.push(item[1]) if bag_count_hash[item[1]].length > 0}
                end
                len -= 1
                total_count += arr[arr.length - 1]
            end
        end
        total_count
    end
end

bg = BarGraph.new
graph_arr = bg.create_graph
puts bg.get_number_of_bags_that_can_hold_bag graph_arr[1], "shiny gold"
puts bg.get_number_of_bag_that_can_be_carried_within "shiny gold", graph_arr[0], graph_arr[2]