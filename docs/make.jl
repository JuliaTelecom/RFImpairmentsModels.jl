push!(LOAD_PATH, "../src/")
using Documenter, RFImpairmentsModels

makedocs(sitename="RFImpairmentsModels.jl", 
		 format = Documenter.HTML(),
		 pages    = Any[
						"Introduction"   => "index.md",
						"Function list"          => "base.md",
						],
		 );

#makedocs(sitename="My Documentation", format = Documenter.HTML(prettyurls = false))

deploydocs(
    repo = "github.com/JuliaTelecom/RFImpairmentsModels.jl",
)
