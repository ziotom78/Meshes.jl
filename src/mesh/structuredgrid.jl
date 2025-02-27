# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    StructuredGrid(X, Y, Z, ...)

A structured grid with vertices at sorted coordinates `X`, `Y`, `Z`, ...

## Examples

Create a 2D structured grid with regular spacing in `x` dimension
and irregular spacing in `y` dimension:

```julia
julia> X = repeat(0.0:0.2:1.0, 1, 6)
julia> Y = repeat([0.0, 0.1, 0.3, 0.7, 0.9, 1.0]', 6, 1)
julia> StructuredGrid(X, Y)
```
"""
struct StructuredGrid{Dim,T,A<:AbstractArray{T}} <: Grid{Dim,T}
  XYZ::NTuple{Dim,A}
  topology::GridTopology{Dim}
end

function StructuredGrid(XYZ::Tuple)
  coords = promote(XYZ...)
  topology = GridTopology(size(first(coords)) .- 1)
  StructuredGrid(coords, topology)
end

StructuredGrid(XYZ...) = StructuredGrid(XYZ)

cart2vert(g::StructuredGrid{Dim}, ijk::Tuple) where {Dim} = Point(ntuple(d -> g.XYZ[d][ijk...], Dim))

XYZ(g::StructuredGrid) = g.XYZ
