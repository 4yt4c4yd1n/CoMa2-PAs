struct Node
    key::Int
    left::Union{Nothing, Node}
    right::Union{Nothing, Node}
end

MaybeNode = Union{Node, Nothing}
#Externe Constructors
node(key::Int)::Node = Node(key, nothing, nothing)
node(key::Int, left::MaybeNode, right::MaybeNode)::Node = Node(key, left, right)


function getKeys(node::Node)::Vector{Int}

    keys = [node.key]
    leftNode = node.left
    rightNode = node.right
    
    # Wenn links oder rechts nicht leer ist
    if !isnothing(leftNode)
        # getKeys von links und die Vektoren verketten
        keys = vcat(keys, getKeys(leftNode))
    end
    if !isnothing(rightNode)
        keys = vcat(keys, getKeys(rightNode))
    end
    
    # Wenn es ein Blatt ist, einfach die Liste zurückgeben
    return keys
end

function height(node::Node)::Int

    leftHeight = 1
    rightHeight = 1

    # Wenn der Knoten ein Blatt ist, wird 1 zurückgegeben.
    if isnothing(node.left) && isnothing(node.right)
        return 1
    end

    # Gehe zu nicht leeren Seiten
    if !isnothing(node.left)
        leftHeight = height(node.left)
    end
    if !isnothing(node.right)
        rightHeight = height(node.right)
    end

    # An jedem Punkt wird die linke und rechte Höhe verglichen und 1 hinzugefügt (Hinzufügen des aktuellen Knotens).
    if leftHeight > rightHeight
        return (leftHeight + 1)
    else
        return (rightHeight + 1)
    end

end

# Hilfsfunktion zum Erstellen eines Nothing-Vektors mit der entsprechenden Anzahl an Elementen
function initVector(node::Node)::Vector{Union{Int,Nothing}}
    vec = Vector{Union{Int, Nothing}}()
    for i in 1:2^height(node)-1
        push!(vec, nothing)
    end
    return vec
end

function tree2vec(node::Node, i::Int=1, vec::Union{Vector{Union{Int, Nothing}}, Nothing}=nothing)::Vector{Union{Int,Nothing}}
    # Beim ersten Mal ausführen
    if isnothing(vec)
        vec = initVector(node)
    end
   
    # Wenn der i-te Key im Baum vorhanden ist
    if i<= length(vec)
        vec[i] = node.key
    end

    # Gehe zu nicht leeren Seiten
    if !isnothing(node.left)
        tree2vec(node.left, 2*i, vec)
    end
    if !isnothing(node.right)
        tree2vec(node.right, 2*i+1, vec)
    end
    
    return vec

end

# Aus irgendeinem Grund wurde tree2vec für einen Vektor aufgerufen
function tree2vec(vec::Vector{Union{Int, Nothing}})::Vector{Union{Int, Nothing}}
    return vec
end


function vec2tree(vec::Vector{Union{Int,Nothing}})::Node
    return vec2treePlus(vec)
end
# Aus irgendeinem Grund wurde vec2tree für einen Knoten aufgerufen
function vec2tree(node::Union{Node, Nothing})::Union{Node, Nothing}
    vec = tree2vec(node)
    return vec2tree(vec)
end

# vec2tree mit geändertem Rückgabetyp
function vec2treePlus(vec::Vector{Union{Int,Nothing}}, i::Int =1)::Union{Node, Nothing}
    # Gibt nothing zurück, wenn der i-Index ungültig ist oder nothing
    if i > length(vec)
        return nothing
    end

    if isnothing(vec[i])
        return nothing
    end

    key = vec[i]
    
    #=
    Erstelle einen neuen Knoten mit dem Key, 
    erstelle rekursiv auch die Knoten für links und rechts
    =#
    x = node(key, vec2treePlus(vec, 2*i), vec2treePlus(vec, 2*i+1))
    return x
end