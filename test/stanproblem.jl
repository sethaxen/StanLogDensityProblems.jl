using BridgeStan
using LogDensityProblems
using StanLogDensityProblems
using Test

const TEST_MODELS = joinpath(@__DIR__, "models")

function get_test_files(name)
    dir = joinpath(TEST_MODELS, name)
    stan_file = joinpath(dir, "$name.stan")
    data = joinpath(dir, "$name.data.json")
    return stan_file, data
end

function get_test_model(name; kwargs...)
    stan_file, data = get_test_files(name)
    return BridgeStan.StanModel(stan_file, data; kwargs...)
end

struct NonNumeric{T}
    x::T
end

@testset "StanProblem" begin
    @testset "constructors" begin
        @testset "StanProblem(model; kwargs...)" begin
            model = get_test_model("regression")
            prob = StanProblem(model)
            @test prob isa StanProblem{typeof(model),false}
            @test prob.model === model
            @test sprint(show, "text/plain", prob) == "StanProblem: regression_model"

            prob2 = StanProblem(model; nan_on_error=true)
            @test prob2 isa StanProblem{typeof(model),true}
            @test prob2.model === model
        end
        @testset "StanProblem(stan_file, data; kwargs...)" begin
            stan_file, data = get_test_files("regression")
            prob = StanProblem(stan_file, data)
            @test prob isa StanProblem{<:BridgeStan.StanModel,false}

            prob2 = StanProblem(
                stan_file, data; nan_on_error=true, make_args=["STAN_THREADS=true"]
            )
            @test prob2 isa StanProblem{<:BridgeStan.StanModel,true}
        end
        @testset "LogDensityProblems interface" begin
            model = get_test_model("regression")
            @testset for nan_on_error in [false, true]
                prob = StanProblem(model; nan_on_error=nan_on_error)
                @test @inferred(LogDensityProblems.capabilities(prob)) ===
                    LogDensityProblems.LogDensityOrder{2}()
                dim = @inferred Int LogDensityProblems.dimension(prob)
                @test dim == BridgeStan.param_unc_num(model)
                @testset for T in (Float32, Float64)
                    x = randn(T, dim)
                    lp = @inferred T LogDensityProblems.logdensity(prob, x)
                    lp2, grad2 = @inferred Tuple{T,Vector{T}} LogDensityProblems.logdensity_and_gradient(
                        prob, x
                    )
                    @test lp2 == lp
                    @test length(grad2) == dim
                    lp3, grad3, hess3 = @inferred Tuple{T,Vector{T},Matrix{T}} LogDensityProblems.logdensity_gradient_and_hessian(
                        prob, x
                    )
                    @test lp3 == lp
                    @test grad3 == grad2
                end
            end
        end
        @testset "`nan_on_error=true` avoids BridgeStan errors" begin
            model = get_test_model("regression")
            prob = StanProblem(model; nan_on_error=false)
            prob2 = StanProblem(model; nan_on_error=true)
            dim = LogDensityProblems.dimension(prob)

            @testset for bad_val in [Inf, -Inf, NaN]
                x = fill(bad_val, dim)

                @test_throws ErrorException LogDensityProblems.logdensity(prob, x)
                @test_throws ErrorException LogDensityProblems.logdensity_and_gradient(
                    prob, x
                )
                @test_throws ErrorException LogDensityProblems.logdensity_gradient_and_hessian(
                    prob, x
                )

                @test isnan(@inferred(LogDensityProblems.logdensity(prob2, x)))

                lp, grad = @inferred LogDensityProblems.logdensity_and_gradient(prob2, x)
                @test isnan(lp)
                @test all(isnan, grad)
                @test length(grad) == dim

                lp2, grad2, hess2 = @inferred LogDensityProblems.logdensity_gradient_and_hessian(
                    prob2, x
                )
                @test isnan(lp2)
                @test all(isnan, grad2)
                @test length(grad2) == dim
                @test all(isnan, hess2)
                @test size(hess2) == (dim, dim)
            end

            @testset "conversions errors still thrown" begin
                x = map(NonNumeric, randn(dim))
                @test_throws MethodError LogDensityProblems.logdensity(prob2, x)
                @test_throws MethodError LogDensityProblems.logdensity_and_gradient(
                    prob2, x
                )
                @test_throws MethodError LogDensityProblems.logdensity_gradient_and_hessian(
                    prob2, x
                )
            end
        end
    end
end
