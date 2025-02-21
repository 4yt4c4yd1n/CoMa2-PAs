struct Pfad
    source::Real
    target::Union{Real, Pfad}
end

pfad(source::Real, target::Real)::Pfad = Pfad(source, target)

pfad(source::Real, target::Pfad)::Pfad = Pfad(source, target)

pfad(source::Real)::Pfad = Pfad(source, source)

⇒(source::Real, target::Real)::Pfad = pfad(source, target)
⇒(source::Real, target::Pfad)::Pfad = pfad(source, target)

function Base.show(io::IO, p::Pfad)
    if typeof(p.target) == Pfad
        print(io, p.source, " ⇒ ")
        Base.show(io::IO, p.target)
    else
        print(io,  p.source, " ⇒ ", p.target)
    end
end

function *(f::Pfad, g::Pfad)
    last = f
    srcArr = []
    while typeof(last.target) == Pfad
        push!(srcArr, last.source)
        last = last.target

    end
    push!(srcArr, last.source)
    @assert last.target == g.source
    for i in length(srcArr):-1:1
        g= srcArr[i] ⇒ g
    end
    return g
end

h = (1 ⇒ 0 ⇒ -1 ⇒ 0.5)
println(h)
x, y, z = (20 ⇒ 3.5, 3.5 ⇒ 1, 2 ⇒ 3.5)
println(x*y)