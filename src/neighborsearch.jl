# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    NeighborSearchMethod

A method for searching neighbors given a reference point.
"""
abstract type NeighborSearchMethod end

"""
    search!(neighbors, pₒ, method; skip=i->false)

Update `neighbors` of point `pₒ` using `method` and return
number of neighbors found. Optionally, specify a `skip`
function to skip indices of the domain.
"""
function search! end

"""
    searchdists!(neighbors, distances, pₒ, method; skip=i->false)

Update `neighbors` and `distances` of point `pₒ` using `method`
and return number of neighbors found. Optionally, specify a
`skip` function to skip indices of the domain.
"""
function searchdists! end

"""
    search(pₒ, method, skip=i->false)

Return neighbors of point `pₒ` using `method`. Optionally,
specify a `skip` function to skip indices of the domain.
"""
function search end

"""
    searchdists(pₒ, method, skip=i->false)

Return neighbors and distances of point `pₒ` using `method`.
Optionally, specify a `skip` function to skip indices of the
domain.
"""
function searchdists end

"""
    BoundedNeighborSearchMethod

A method for searching neighbors with the property that the number of neighbors
is bounded above by a known constant (e.g. k-nearest neighbors).
"""
abstract type BoundedNeighborSearchMethod <: NeighborSearchMethod end

"""
    maxneighbors(method)

Return the maximum number of neighbors obtained with `method`.
"""
function maxneighbors end

# ----------
# FALLBACKS
# ----------

function search!(neighbors, pₒ::Point, method::BoundedNeighborSearchMethod; skip=i -> false)
  distances = Vector{coordtype(pₒ)}(undef, maxneighbors(method))
  searchdists!(neighbors, distances, pₒ, method; skip)
end

function search(pₒ::Point, method::BoundedNeighborSearchMethod; skip=i -> false)
  neighbors = Vector{Int}(undef, maxneighbors(method))
  nneigh = search!(neighbors, pₒ, method; skip)
  view(neighbors, 1:nneigh)
end

function searchdists(pₒ::Point, method::BoundedNeighborSearchMethod; skip=i -> false)
  neighbors = Vector{Int}(undef, maxneighbors(method))
  distances = Vector{coordtype(pₒ)}(undef, maxneighbors(method))
  nneigh = searchdists!(neighbors, distances, pₒ, method; skip)
  view(neighbors, 1:nneigh), view(distances, 1:nneigh)
end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("neighborsearch/ball.jl")
include("neighborsearch/knearest.jl")
include("neighborsearch/kball.jl")
