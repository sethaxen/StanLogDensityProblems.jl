using BridgeStan
using LogDensityProblems
using PosteriorDB
using StanLogDensityProblems
using Test

@testset "PosteriorDB integration" begin
    pdb = PosteriorDB.database()
    post = PosteriorDB.posterior(pdb, "dogs-dogs")
    @testset for nan_on_error in (false, true)
        path = mktempdir(; cleanup=false)
        stan_file = joinpath(path, "dogs.stan")
        prob = StanProblem(post, path; nan_on_error=nan_on_error)
        @test prob isa StanProblem{<:BridgeStan.StanModel,nan_on_error}
        @test isfile(stan_file)
        dim = LogDensityProblems.dimension(prob)
        x = randn(dim)
        LogDensityProblems.logdensity(prob, x)

        # Because Stan file has not changed, no error raised.
        prob2 = StanProblem(post, path; nan_on_error=nan_on_error)
        LogDensityProblems.logdensity(prob2, x)

        # Because file exists but is nonidentical, error raised.
        # `cp` copies with the original permissions, so we can't modify the copy unless we
        # change the permissions
        chmod(stan_file, 0o644)
        open(println, stan_file; append=true)
        @test_throws ArgumentError StanProblem(post, path; nan_on_error=nan_on_error)

        # Force re-copying Stan file.
        prob3 = StanProblem(post, path; force=true, nan_on_error=nan_on_error)
        LogDensityProblems.logdensity(prob3, x)
    end
end
