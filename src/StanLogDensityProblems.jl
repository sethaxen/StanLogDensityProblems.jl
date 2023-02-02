module StanLogDensityProblems

using BridgeStan: BridgeStan
using LogDensityProblems: LogDensityProblems

export StanProblem

include("stanproblem.jl")

end
