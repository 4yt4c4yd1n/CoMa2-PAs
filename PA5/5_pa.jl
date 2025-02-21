using AbstractTrees

mutable struct Node
    value::Union{Char,Nothing}
    freq::Int
    left::Union{Node,Nothing}
    right::Union{Node,Nothing}
end

function getFrequencies(text::String)::Dict{Char, Int}
    freqs = Dict{Char, Int}()
    for i in eachindex(text)
        if haskey(freqs, text[i])
            freqs[text[i]] += 1
        else
            freqs[text[i]] = 1
        end
    end
    
    return freqs
end

function findLowestTwo(q1::Vector{Node}, q2::Vector{Node})::Tuple{Node, Node}

    lowest = Node(nothing, typemax(Int), nothing, nothing)
    lowestList = 0
    lowestIndex = 0
    secondLowest = Node(nothing, typemax(Int), nothing, nothing)
    secondLowestList = 0
    secondLowestIndex = 0

    for i in 1:2
        if i > length(q1)
            break
        end
        if q1[i].freq < lowest.freq
            lowest = q1[i]
            lowestList = 1
            lowestIndex = i
        elseif q1[i].freq < secondLowest.freq
            secondLowest = q1[i]
            secondLowestList = 1
            secondLowestIndex = i
        end
    end
    for i in 1:2
        if i > length(q2)
            break
        end
        if q2[i].freq < lowest.freq
            lowest = q2[i]
            lowestList = 2
            lowestIndex = i
        elseif q2[i].freq < secondLowest.freq
            secondLowest = q2[i]
            secondLowestList = 2
            secondLowestIndex = i
        end
    end

    if lowestList == secondLowestList
        secondLowestIndex -= 1
    end

    if lowestList == 1
        deleteat!(q1, lowestIndex)
    elseif lowestList ==2
        deleteat!(q2, lowestIndex)
    end
    if secondLowestList == 1
        deleteat!(q1, secondLowestIndex)
    elseif secondLowestList ==2
        deleteat!(q2, secondLowestIndex)
    end

    return (lowest, secondLowest)
end

function findLowestTwoSingle(q1::Vector{Node})::Union{Node, Tuple{Node, Node}}
    if length(q1) == 1
        lowest = q1[1]
        popat!(q1, 1)
        return lowest
    end
    lowest = Node(nothing, typemax(Int), nothing, nothing)
    lowestIndex = 1
    secondLowest = Node(nothing, typemax(Int), nothing, nothing)
    secondLowestIndex = 1
    
    for i in 1:2
        if q1[i].freq < lowest.freq
            lowest = q1[i]
            lowestIndex = i
        elseif q1[i].freq < secondLowest.freq
            secondLowest = q1[i]
            secondLowestIndex = i
        end
    end

    popat!(q1, lowestIndex)
    popat!(q1, secondLowestIndex-1)

    return (lowest, secondLowest)
end

function huffman_tree(freqs::Dict{Char,Int})::Node
    list1 = Vector{Node}()
    list2 = Vector{Node}()
    display(freqs)
    println(keys(freqs))
    for elem in keys(freqs)
        push!(list1, Node(elem, freqs[elem], nothing, nothing))
    end
    node_sort!(list1)
    display(list1)
    while length(list1) + length(list2) > 1 
        
        lowest, secondLowest = findLowestTwo(list1, list2)
    
        T = Node(nothing, lowest.freq + secondLowest.freq, lowest, secondLowest)
        push!(list2, T)
        
    end
    return list2[1]
end

function node_sort!(l::Vector{Node})::Nothing
    
    for i in 1:length(l)-1       
        for j in i+1:length(l)
            if l[j].freq < l[i].freq
                tmp = l[i]
                l[i] = l[j]
                l[j] = tmp
            end
        end
    end
    
    return
end

function Encode(text::String, code::Dict{Char, String})::String
    encodedString = ""
    for i in eachindex(text)
        encodedString *= code[text[i]]
    end
    return encodedString
end

function Decode(encoded::String, tree::Node)::String
    node_iterator = tree
    decodedString = ""

    for i in eachindex(encoded)
        
        if encoded[i] == '0' 
            node_iterator = node_iterator.left
        else
            node_iterator = node_iterator.right
        end

        if !isnothing(node_iterator.value)
            decodedString *= node_iterator.value
            node_iterator = tree
        end
    end

    return decodedString
end
function getKeys(node::Node)::Vector{Union{Char, Nothing}}
    keys = [node.value]
    leftNode = node.left
    rightNode = node.right
    
    if !isnothing(leftNode)
        keys = vcat(keys, getKeys(leftNode))
    end
    if !isnothing(rightNode)
        keys = vcat(keys, getKeys(rightNode))
    end
    return keys
end

function huffman_code(tree::Node)
    table = Dict{Char, String}()
    
    for i in getKeys(tree)
        if !isnothing(i)
            table[i]= path(tree, i)
        end
    end
    return table
end

function path(node::Node, key::Char, pathStr::String="")::String
    if node.value == key
        return pathStr
    end
    if isnothing(node.left) && isnothing(node.right)
        return ""
    end

    leftpath = path(node.left, key, pathStr*'0')
    rightpath = path(node.right, key, pathStr*'1')

    return length(leftpath) > length(rightpath) ? leftpath : rightpath
end

#test = 'a'^45*'b'^13*'c'^12*'d'^16*'e'^9*'f'^5
#test = "Wenn der Physiker nicht weiter weiß, gründet er ein Arbeitskreis"
#test = "mississippi"
test = "Das Weltall ist größer als man denkt."
tree = huffman_tree(getFrequencies(test))
#=
pathT = huffman_code(tree)
display(pathT)
encoded = Encode(test, pathT)
println(encoded)
println(Decode(encoded, tree))
println(test)=#
#println(findLowestTwo([Node(nothing,1,nothing,nothing), Node(nothing,4,nothing,nothing)], [Node(nothing,2,nothing,nothing), Node(nothing,3,nothing,nothing)]))
display(tree)
display(getFrequencies(test))
d = OrderedDict{Char,Int}()
println(typeof(d))