module StanLogDensityProblemsPosteriorDBExt

using StanLogDensityProblems: StanLogDensityProblems, EXTENSIONS_SUPPORTED

if EXTENSIONS_SUPPORTED
    using PosteriorDB: PosteriorDB
else  # using Requires
    using ..PosteriorDB: PosteriorDB
end

"""
    StanProblem(
        posterior::PosteriorDB.Posterior,
        path::AbstractString,
        args...;
        nan_on_error::Bool=false,
        force::Bool=false,
        kwargs...,
    )

Construct a `StanProblem` from the Stan model implementation and dataset corresponding to
`posterior`.

The model file will be copied to `path` before compilation. `force=true` will first remove
an existing file. However, if the original file has already been compiled in this directory,
the new model will not be compiled.

Remaining `args` and `kwargs` are forwarded to the main constructor.
"""
function StanLogDensityProblems.StanProblem(
    post::PosteriorDB.Posterior, path::AbstractString, args...; force::Bool=false, kwargs...
)
    model = PosteriorDB.model(post)
    stan_file = PosteriorDB.path(PosteriorDB.implementation(model, "stan"))
    stan_file_new = joinpath(path, basename(stan_file))
    cp(stan_file, stan_file_new; force=force)
    data = PosteriorDB.load(PosteriorDB.dataset(post), String)
    return StanLogDensityProblems.StanProblem(stan_file_new, data, args...; kwargs...)
end

end  # module
