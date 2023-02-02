module PosteriorDBExt

using StanLogDensityProblems: StanLogDensityProblems, EXTENSIONS_SUPPORTED

if isdefined(Base, :get_extension)
    using PosteriorDB: PosteriorDB
else  # using Requires
    using ..PosteriorDB: PosteriorDB
end

"""
    StanProblem(posterior::PosteriorDB.Posterior; nan_on_error::Bool=false, kwargs...)

Construct a `StanProblem` from the Stan model implementation and dataset corresponding to
`posterior`.
"""
function StanLogDensityProblems.StanProblem(post::PosteriorDB.Posterior; kwargs...)
    model = PosteriorDB.model(post)
    stan_file = PosteriorDB.path(PosteriorDB.implementation(model, "stan"))
    data = PosteriorDB.load(PosteriorDB.dataset(post), String)
    return StanLogDensityProblems.StanProblem(stan_file, data; kwargs...)
end

end  # module
