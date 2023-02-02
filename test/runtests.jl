using StanLogDensityProblems
using Test

@testset "StanLogDensityProblems.jl" begin
    include("stanproblem.jl")
    include("posteriordb.jl")
end
