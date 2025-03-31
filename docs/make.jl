using StanLogDensityProblems
using Documenter
using DocumenterInterLinks
using PosteriorDB  # load extension

DocMeta.setdocmeta!(
    StanLogDensityProblems, :DocTestSetup, :(using StanLogDensityProblems); recursive=true
)

links = InterLinks(
    "BridgeStan" => (
        "https://roualdes.github.io/bridgestan/latest/",
        joinpath(@__DIR__, "inventories", "BridgeStan.toml"),
    ),
)

makedocs(;
    modules=[StanLogDensityProblems],
    authors="Seth Axen <seth@sethaxen.com> and contributors",
    repo="https://github.com/sethaxen/StanLogDensityProblems.jl/blob/{commit}{path}#{line}",
    sitename="StanLogDensityProblems.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://sethaxen.github.io/StanLogDensityProblems.jl",
        edit_link="main",
        assets=String[],
    ),
    plugins=[links],
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/sethaxen/StanLogDensityProblems.jl", devbranch="main")
