var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = StanLogDensityProblems","category":"page"},{"location":"#StanLogDensityProblems","page":"Home","title":"StanLogDensityProblems","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"StanLogDensityProblems implements the LogDensityProblems API for Stan models using BridgeStan. For easily benchmarking inference algorithms, StanLogDensityProblems also integrates with PosteriorDB.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [\n    StanLogDensityProblems,\n    isdefined(Base, :get_extension) ? Base.get_extension(StanLogDensityProblems, :PosteriorDBExt) : StanLogDensityProblems.PosteriorDBExt\n]","category":"page"},{"location":"#StanLogDensityProblems.StanProblem","page":"Home","title":"StanLogDensityProblems.StanProblem","text":"StanProblem(model::BridgeStan.StanModel; nan_on_error::Bool=false)\n\nA wrapper for a Stan model with data, implementing the LogDensityProblems interface.\n\nIf nan_on_error=true, then any errors from Stan will be suppressed, and NaNs will be returned.\n\n\n\n\n\n","category":"type"},{"location":"#StanLogDensityProblems.StanProblem-Tuple{String, String}","page":"Home","title":"StanLogDensityProblems.StanProblem","text":"StanProblem(stan_file::String, data::String; nan_on_error::Bool=false, kwargs...)\n\nConstruct a BridgeStan.StanModel from a .stan file and wrap it as a StanProblem.\n\ndata should either be a string containing a JSON string literal or a path to a data file ending in .json. If necessary, the model is compiled.\n\nRemaining kwargs are forwarded to BridgeStan.StanModel.\n\nnote: Note\nBy default, Stan does not compile the model with multithreading support. If this is needed, pass make_args=[\"STAN_THREADS=true\"] to kwargs.\n\n\n\n\n\n","category":"method"},{"location":"#StanLogDensityProblems.StanProblem-Tuple{Posterior}","page":"Home","title":"StanLogDensityProblems.StanProblem","text":"StanProblem(posterior::PosteriorDB.Posterior; nan_on_error::Bool=false, kwargs...)\n\nConstruct a StanProblem from the Stan model implementation and dataset corresponding to posterior.\n\n\n\n\n\n","category":"method"}]
}
