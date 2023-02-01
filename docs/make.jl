using StanLogDensityProblems
using Documenter

DocMeta.setdocmeta!(
    StanLogDensityProblems, :DocTestSetup, :(using StanLogDensityProblems); recursive=true
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
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/sethaxen/StanLogDensityProblems.jl", devbranch="main")
