# frozen_string_literal: true

require 'net/http'
require 'pry'
require 'set'
require 'json'

# URL Endpoint for retrieving node children ids
ENDPOINT = 'https://nodes-on-nodes-challenge.herokuapp.com/nodes/'
# Starting node id
START_ID = '089ef556-dfff-4ff2-9733-654645be56fe'

# @param start_id [String] the starting node id
# @return [Hash] the count of nodes in the graph node ids
def traverse_node(start_id)
    uniq_node_ids = Set.new([start_id])
    untraversed_ids = [start_id]

    while !untraversed_ids.empty?
        uri = URI(ENDPOINT + untraversed_ids.join(','))
        response = JSON.parse(Net::HTTP.get(uri))

        children_ids = response.map { |res| res['child_node_ids'] }.flatten

        untraversed_ids = children_ids.select { |id| !uniq_node_ids.include?(id) }
        uniq_node_ids.merge(untraversed_ids)
    end

    { 
        count: uniq_node_ids.count,
        uniq_node_ids: uniq_node_ids.to_a
    }
end

puts traverse_node(START_ID)
