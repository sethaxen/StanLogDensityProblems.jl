module StanLogDensityProblemsPosteriorDBExt

using StanLogDensityProblems: StanLogDensityProblems, EXTENSIONS_SUPPORTED

if EXTENSIONS_SUPPORTED
    using PosteriorDB: PosteriorDB
    using SHA: SHA
else  # using Requires
    using ..PosteriorDB: PosteriorDB
    using ..SHA: SHA
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
    if !isfile(stan_file_new) || !_is_file_identical(stan_file_new, stan_file)
        cp(stan_file, stan_file_new; force=force)
    end
    data = PosteriorDB.load(PosteriorDB.dataset(post), String)
    return StanLogDensityProblems.StanProblem(stan_file_new, data, args...; kwargs...)
end

_is_file_identical(f1::AbstractString, f2::AbstractString) = _hash(f1) == _hash(f2)

_hash(file::AbstractString) = open(SHA.sha256, file; read=true)

end  # module
