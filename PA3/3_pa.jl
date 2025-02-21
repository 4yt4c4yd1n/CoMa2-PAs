mutable struct Heap{T <: Real}
    data::Vector{T}
    comparator::Function 

    function Heap(data::Vector{T}; comparator::Function) where T <: Real
        @assert hasmethod(comparator, Tuple{T, T})
        @assert Base.return_types(comparator, Tuple{T, T}) == [Bool]
        new{T}(data, comparator)
    end

    function Heap(data::Vector{T}) where T <: Real
        @assert hasmethod(>=, Tuple{T, T})
        @assert Base.return_types(>=, Tuple{T, T}) == [Bool]
        new{T}(data, >=)
    end

end

function heap(data::Vector{T}; comparator::Function)::Heap{T} where T<:Real
    return heapify!(Heap(data, comparator=comparator))
end
#[1, 5, 6, 2] =< false
function is__Heap(heap::Heap{T}, i::Int=1)::Bool where T<:Real
    
    if 2i +1 > length(heap.data) && 2i > length(heap.data)
        return true
    elseif 2i == length(heap.data)
        if heap.comparator(heap.data[i], heap.data[2i]) && is__Heap(heap, 2i)
            return true
        end
    else
        if heap.comparator(heap.data[i], heap.data[2i+1]) && heap.comparator(heap.data[i], heap.data[2i]) && is__Heap(heap, 2i+1) && is__Heap(heap, 2i)
            return true
        end
    end
   

    return false
end

function heapify!(heap::Heap{T}) where T<:Real
    
    heapSort!(heap)
    for i in length(heap.data)÷2+1:-1:1
        _heapify(heap.data, i, length(heap.data), heap.comparator)
    end
    return heap
end

function _heapify(data::Vector{T}, i::Int, size::Int, comparator::Function) where T<:Real
    target_i = i
    left = 2*i
    right = 2*i + 1

    if left <= size && comparator(data[left], data[target_i])
        target_i = left
    end

    if right <= size && comparator(data[right], data[target_i])
        target_i = right
    end

    if target_i != i
        #swap
        tmp = data[target_i]
        data[target_i] = data[i]
        data[i] = tmp

        data = _heapify(data, target_i, size, comparator)
    end
    
end

function heapSort!(heap::Heap)::Heap
    
    for i in 1:length(heap.data)-1
                
        for j in i+1:length(heap.data)

            if heap.comparator(heap.data[i], heap.data[j])
                tmp = heap.data[i]
                heap.data[i] = heap.data[j]
                heap.data[j] = tmp
            end
              
        end

    end

    return heap
end
function heapSort!(data::Vector{T}; comparator::Function)::Vector{T} where {T<:Real}
    x = Heap(data, comparator=comparator)
    
    return heapSort!(x).data
end

function maximum(heap::Heap{T})::T where {T<:Real}
    a = heap.data[1]

    for i in 2:length(heap.data)
        if heap.data[i] > a
            a = heap.data[i]
        end
    end
    return a
end


#=println(Heap([1, 2, 3, 4]))
println(is__Heap(Heap([1,2,3,4,5,6,7], comparator = (x,y)->x<=y)))
x = Heap([1,2,3,4,5,6,7], comparator=(x,y)->x>=y)

println(heapify!(x))
println(heap([1,2,3,4,5,6,7], comparator=(x,y)->x>=y))

h1 = heap([1,7,3,5,6,4,2], comparator=(x,y)->x>=y)
println(heapSort!(h1))

println(maximum(heap([1,7,3,5,6,4,2], comparator=(x,y)->x>=y)))
println(is__Heap(heapify!(Heap([8, 19, 18, 4, 11, 15, 9, 20, 14, 3], comparator=(x,y)->x>=y))))
println(heapify!(Heap([8, 19, 18, 4, 11, 15, 9, 20, 14, 3], comparator=(x,y)->x>=y)))
println(heapSort!([19, 4, 11, 16, 15, 3, 9, 20, 8, 7], comparator=(x,y)->x>=y))
println(maximum(heap([7, 15, 6, 16, 4, 5, 10, 12, 13, 17], comparator=(x,y)->x>=y)))
display(heapSort!([13, 19, 5, 20, 3, 7, 8, 12, 4, 17], comparator=(x,y)->x>=y))
display(heapSort!([91,2,99,4,97,6,7], comparator=(x,y)->x<=y))
println(maximum(heap([7, 15, 6, 16, 4, 5, 10, 12, 13, 17], comparator=(x,y)->x>=y)))=#
#=println(is__Heap(Heap([1, 5, 6, 2], comparator = (x,y)->x<=y)))
println(is__Heap(Heap([1,2,3,4,5,6,7], comparator=(x,y)->x>=y)))
println(is__Heap(Heap([1,2,3,4,5,6,7], comparator=(x,y)->x<=y)))

println(is__Heap(Heap([12, 14, 8, 16, 3, 13, 15, 17, 1, 7], comparator=(x,y)->x<=y)))=#