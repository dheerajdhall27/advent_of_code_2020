# Created by Dheeraj Dhall - 12/27/2020

require '../common/file_reader'

class ShuttleSearch

    def initialize
        @rows = FileReader.new.get_file_data("input.rtf").split("\n")
    end

    # This method is used to parse the string and split into 
    # respective the timestamp and the bus id array
    def get_departure_timestamp_and_bus_ids
        ids = []
        ids_as_string_arr = @rows[1].split(",")

        ids_as_string_arr.each do |id|
            next if id == "x"
            ids.push(id.to_i)
        end

        [@rows[0].to_i, ids]
    end

    # This method is used to get the waiting time for the bus
    # and the bus Id that the passenger will board
    # @args: ts - the earliest the passenger can leave
    # @args: bus_ids : All the bus_ids
    def get_waiting_time_and_bus_id ts, bus_ids
        min_id = ts
        min_wait_time = ts

        bus_ids.each do |id|
            next if id > ts

            trips_to_get_close_to_ts = ts.to_f / id

            if trips_to_get_close_to_ts == 0
                min_id = id
                min_wait_time = 0
                break
            end

            this_ids_ts_close_to_ts = id * trips_to_get_close_to_ts.to_i + id

            waiting_time = this_ids_ts_close_to_ts - ts
            if waiting_time < min_wait_time
                min_id = id
                min_wait_time = waiting_time
            end
        end

        [min_wait_time, min_id]
    end

    def get_original_offsets
        ids_arr = @rows[1].split(",")
        offset_arr = []
        offset_arr.push(0)
        for i in 1..ids_arr.length - 1
            next if ids_arr[i] == "x"
            offset_arr.push(i)
        end

        offset_arr
    end

    def get_ts_at_which_offsets_match ids, offset_arr
        base = ids[0]
        period = ids[0]

        for i in 1..offset_arr.length - 1
            while((base + offset_arr[i]) % ids[i] != 0) 
                base += period
            end
            period *= ids[i]
        end

        base
    end
end

ss = ShuttleSearch.new
data = ss.get_departure_timestamp_and_bus_ids

bus_info = ss.get_waiting_time_and_bus_id data[0], data[1]

# puts bus_info[0] * bus_info[1]
# puts ss.get_original_offsets.to_s
start = Time.now
puts ss.get_ts_at_which_offsets_match data[1], ss.get_original_offsets
final = Time.now
puts final - start