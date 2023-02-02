using LogDensityProblems
using PosteriorDB
using StanLogDensityProblems
using Test

@testset "PosteriorDB integration" begin
    pdb = PosteriorDB.database()
    post = posterior(pdb, "dogs-dogs")
    @testset for nan_on_error in (false, true)
        prob = StanProblem(post; nan_on_error=nan_on_error)
        @test prob isa StanProblem{<:BridgeStan.StanModel,nan_on_error}
        dim = LogDensityProblems.dimension(prob)
        x = randn(dim)
        LogDensityProblems.logdensity(prob, x)
    end
end
