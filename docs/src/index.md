```@meta
CurrentModule = StanLogDensityProblems
```

# StanLogDensityProblems

StanLogDensityProblems implements the [LogDensityProblems API](https://www.tamaspapp.eu/LogDensityProblems.jl/) for [Stan](https://mc-stan.org/) models using [BridgeStan](https://roualdes.github.io/bridgestan/).
For easily benchmarking inference algorithms, StanLogDensityProblems also integrates with [PosteriorDB](https://github.com/sethaxen/PosteriorDB.jl).

```@autodocs
Modules = [
    StanLogDensityProblems,
    isdefined(Base, :get_extension) ?
        Base.get_extension(StanLogDensityProblems, :StanLogDensityProblemsPosteriorDBExt) :
        StanLogDensityProblems.StanLogDensityProblemsPosteriorDBExt
]
```
