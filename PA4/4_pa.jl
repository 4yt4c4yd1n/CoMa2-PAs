mutable struct Node
    value::Int
    parent::Union{Node, Nothing}
end
#what
function union_find(data::Vector{Tuple{Int, Vector{Int}}})::Dict{Int, Node}

    dict = Dict()

    for tup in data

        dict[tup[1]] = Node(tup[1], nothing)
        
        for item in tup[2]

            if item == tup[1]
                continue
            else
                dict[item] = Node(item, dict[tup[1]])
            end
        
        end
    end
    
    return dict
end

function find_set(node::Node)::Node

    while !isnothing(node.parent)
        node = node.parent
    end
    return node
end

function find_set!(node::Node)::Node
    if !isnothing(node.parent)
        node.parent = find_set!(node.parent)
        return node.parent
    else
        return node
    end
end

function union!(node1::Node, node2::Node)::Nothing

    if node1 == node2
        return nothing
    end
    
    node1root = find_set!(node1)
    node2root = find_set!(node2)

    if node1root == node2root
        return nothing
    end

    node2root.parent = node1root
    return nothing
end

function add!(nodes::Dict{Int, Node}, value::Int)::Nothing

    @assert !haskey(nodes, value) "The element $(value) is already in the partition"

    nodes[value] = Node(value, nothing)
    return nothing
end