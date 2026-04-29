"""
    StanProblem(
        model::BridgeStan.StanModel;
        nan_on_error::Bool=false,
        log_density_kwargs::NamedTuple=(;)
    )

A wrapper for an unconstrained Stan model with data, implementing the
[LogDensityProblems](https://www.tamaspapp.eu/LogDensityProblems.jl/) interface.

If `nan_on_error=true`, then any errors from Stan will be suppressed, and `NaN`s will be
returned.

`log_density_kwargs` is a `NamedTuple` of keyword arguments that is passed to BridgeStan's
log-density functions. This can include the `propto` and `jacobian` keys. See e.g. the
docstring for [`BridgeStan.log_density`](@extref),
[BridgeStan.log_density_gradient](@extref), and [`BridgeStan.log_density_hessian`](@extref)
for details.
"""
struct StanProblem{M<:BridgeStan.StanModel,nan_on_error,L<:NamedTuple}
    model::M
    log_density_kwargs::L
    function StanProblem(
        model::M; nan_on_error::Bool=false, log_density_kwargs::L=(;)
    ) where {M<:BridgeStan.StanModel,L<:NamedTuple}
        return new{M,nan_on_error,L}(model, log_density_kwargs)
    end
end

"""
    StanProblem(lib::String[, data::String[ seed::Int]]; nan_on_error::Bool=false, kwargs...)

Construct a [`BridgeStan.StanModel`](@extref) and wrap it as a `StanProblem`.

`lib` is a path either to a compiled Stan model or to a `.stan` file. For details on the
arguments, see the docstring for [`BridgeStan.StanModel`](@extref).

!!! note
    By default, Stan does not compile the model with multithreading support. If this is
    needed, pass `make_args=["STAN_THREADS=true"]` to `kwargs`.
"""
function StanProblem(
    args...; nan_on_error::Bool=false, log_density_kwargs::NamedTuple=(;), kwargs...
)
    model = BridgeStan.StanModel(args...; kwargs...)
    return StanProblem(
        model; nan_on_error=nan_on_error, log_density_kwargs=log_density_kwargs
    )
end

function Base.show(io::IO, ::MIME"text/plain", prob::StanProblem)
    return print(io, "StanProblem: $(BridgeStan.name(prob.model))")
end

function LogDensityProblems.capabilities(::Type{<:StanProblem})
    return LogDensityProblems.LogDensityOrder{2}()  # can do gradient
end

function LogDensityProblems.dimension(prob::StanProblem)
    return Int(BridgeStan.param_unc_num(prob.model))
end

function LogDensityProblems.logdensity(
    prob::StanProblem{M,nan_on_error}, x
) where {M,nan_on_error}
    m = prob.model
    z = convert(Vector{Float64}, x)
    try
        return BridgeStan.log_density(m, z; prob.log_density_kwargs...)
    catch
        nan_on_error || rethrow()
        return NaN
    end
end

function LogDensityProblems.logdensity_and_gradient(
    prob::StanProblem{M,nan_on_error}, x
) where {M,nan_on_error}
    m = prob.model
    z = convert(Vector{Float64}, x)
    try
        return BridgeStan.log_density_gradient(m, z; prob.log_density_kwargs...)
    catch
        nan_on_error || rethrow()
        n = BridgeStan.param_unc_num(m)
        return (NaN, fill(NaN, n))
    end
end

function LogDensityProblems.logdensity_gradient_and_hessian(
    prob::StanProblem{M,nan_on_error}, x
) where {M,nan_on_error}
    m = prob.model
    z = convert(Vector{Float64}, x)
    try
        return BridgeStan.log_density_hessian(m, z; prob.log_density_kwargs...)
    catch
        nan_on_error || rethrow()
        n = BridgeStan.param_unc_num(m)
        return NaN, fill(NaN, n), fill(NaN, n, n)
    end
end
