# StanLogDensityProblems

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sethaxen.github.io/StanLogDensityProblems.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sethaxen.github.io/StanLogDensityProblems.jl/dev/)
[![Build Status](https://github.com/sethaxen/StanLogDensityProblems.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/sethaxen/StanLogDensityProblems.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/sethaxen/StanLogDensityProblems.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/sethaxen/StanLogDensityProblems.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

StanLogDensityProblems implements the [LogDensityProblems API](https://www.tamaspapp.eu/LogDensityProblems.jl/) for [Stan](https://mc-stan.org/) models using [BridgeStan](https://roualdes.github.io/bridgestan/).
For easily benchmarking inference algorithms, StanLogDensityProblems also integrates with [PosteriorDB](https://github.com/sethaxen/PosteriorDB.jl).

For example, here we sample a Stan model from PosteriorDB using [DynamicHMC](https://www.tamaspapp.eu/DynamicHMC.jl):

```julia
julia> using BridgeStan, DynamicHMC, PosteriorDB, Random, StanLogDensityProblems

julia> pdb = PosteriorDB.database()
PosteriorDatabase(...)

julia> post = PosteriorDB.posterior(pdb, "dogs-dogs")
Posterior: dogs-dogs

julia> prob = StanProblem(post, ".")
StanProblem: dogs_model

julia> rng = Random.default_rng();

julia> result = mcmc_with_warmup(rng, prob, 1_000; reporter=NoProgressReport());
```