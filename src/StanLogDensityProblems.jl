module StanLogDensityProblems

using BridgeStan: BridgeStan
using LogDensityProblems: LogDensityProblems

export StanProblem

include("stanproblem.jl")

const EXTENSIONS_SUPPORTED = isdefined(Base, :get_extension)
EXTENSIONS_SUPPORTED || using Requires: @require

function __init__()
    @static if !EXTENSIONS_SUPPORTED
        @require PosteriorDB = "1c4bc282-d2f5-44f9-b6d1-8c4424a23ad4" begin
            include("../ext/StanLogDensityProblemsPosteriorDBExt.jl")
        end
    end
end

end  # module
