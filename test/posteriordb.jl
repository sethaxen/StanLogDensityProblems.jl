using LogDensityProblems
using PosteriorDB
using StanLogDensityProblems
using Test

@testset "PosteriorDB integration" begin
    pdb = PosteriorDB.database()
    post = posterior(pdb, "dogs-dogs")
    @testset for nan_on_error in (false, true)
        path = mktempdir(; cleanup=false)
        prob = StanProblem(post, path; nan_on_error=nan_on_error)
        @test prob isa StanProblem{<:BridgeStan.StanModel,nan_on_error}
        @test isfile(joinpath(path, "dogs.stan"))
        dim = LogDensityProblems.dimension(prob)
        x = randn(dim)
        LogDensityProblems.logdensity(prob, x)
        @test_throws ArgumentError StanProblem(post, path; nan_on_error=nan_on_error)
        prob2 = StanProblem(post, path; force=true, nan_on_error=nan_on_error)
        LogDensityProblems.logdensity(prob2, x)
    end
end
