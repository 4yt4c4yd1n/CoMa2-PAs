mutable struct FactorTree
    value::Int
    left::Union{FactorTree, Nothing}
    right::Union{FactorTree, Nothing}

    function FactorTree(v::Int)::FactorTree
        node = new(v, nothing, nothing)
        if isprime(v) || v == 1
            return node
        end
        divs = findClosestDivisors(v)
        if divs[2] >= divs[1]
            node.right = FactorTree(divs[2])
            node.left = FactorTree(divs[1])
        else
            node.right = FactorTree(divs[1])
            node.left = FactorTree(divs[2])
        end
        return node
    end
end

function getFactors(t::FactorTree)::Dict{Int, Int}
    leaves = getLeaves(t)
    dic = Dict{Int, Int}()
    for l in leaves
        if haskey(dic, l)
            dic[l] += 1
        else
            dic[l] = 1 
        end
    end
    return dic
end

function getLeaves(t::FactorTree)
    leaves=[]
    if isnothing(t.left) && isnothing(t.right)
        return [t.value]
    end
    leaves = append!(getLeaves(t.left), getLeaves(t.right))
    return leaves
end

function getShape(t::FactorTree)::String
    if isnothing(t.right) && isnothing(t.right)
        return "p"
    end
    if isprime(t.right.value) && isprime(t.left.value)
        return "p2"
    end
    if isprime(t.right.value)
        return "f(p2|p)"
    elseif isprime(t.left.value)
        return "f(p|p2)"
    else
        return "f(p2|p2)"
    end
end

function compareShape(t::FactorTree, h::FactorTree)::Bool
    tstr = getShape(t)
    hstr = getShape(h)
    return tstr == hstr
end

function computeShapes(n::Int)::Dict{String, Vector{Int}}
    dic = Dict{String, Vector{Int}}()
    for i=1:n
        t = FactorTree(i)
        shapeT= getShape(t)
        if haskey(dic, shapeT)
            push!(dic[shapeT], i)
        else
            dic[shapeT] = [i]
        end
    end
    return dic
end

function isprime(n)
    if typeof(n) != Int
        return false
    end
    if n <= 1
        return false
    end
    nSqrt = floor(Int, sqrt(n))
    for i=2:nSqrt
        if n % i == 0
            return false
        end
    end
    return true
end

function findClosestDivisors(n)
    closest = [typemax(Int), 0]
    for i=floor(Int, sqrt(n)):-1:1
        if n % i == 0
            if n/i - i < closest[1] - closest[2]
                closest[1] = n/i
                closest[2] = i
            end
        end
    end
    return closest
end