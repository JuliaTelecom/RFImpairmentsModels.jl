# ----------------------------------------------------
# --- Phase Noise 
# --------------------------------------------------- 
abstract type PhaseNoiseModel end

mutable struct WienerPhaseNoise_1 <: PhaseNoiseModel 
    σ2::Float64      # State Noise variance 
    seed::Int64     # Seed for PN Variation 
    ϕ̄::Float64      # Current phase value (for continuity call)
    counter::Int    # Counter for seed generations
end
WienerPhaseNoise = WienerPhaseNoise_1 # For Revise

""" Instantiate a phase noise model, with specific model and associated parameters
- Wiener => Wiener phase noise parametrized by the normalized state noise variance 
"""
function initPhaseNoise(model::Symbol;σ2=0,seed=-1)
    if model == :Wiener 
        # --- Instantiate the PN 
        pn = WienerPhaseNoise(σ2,seed,0,0)
    else 
        @error "Unknown Phase noise model" 
    end
    return pn 
end

""" Add phase noise parametrized by pn to the input signal x
There are 3 versions 
- One with allocation of the output y = addPhaseNoise(x,pn)
- One with in place mutation of the first vector addPhaseNoise!(y,x,pn)
- One with in place mutation of the input vector addPhaseNoise!(x,pn)
"""
function addPhaseNoise!(y::AbstractVector{Complex{T}},x,pn::PhaseNoiseModel) where T
    # Shortcut for fast Wiener ?
    if pn isa WienerPhaseNoise 
        if pn.seed == -1 
            Random.MersenneTwister()
        else 
            Random.seed!(pn.seed + pn.counter )
        end
        # --- Phase continuity 
        # Last phase value is set as initial phase
        ϕ̄ = pn.ϕ̄
        @inbounds @simd for n ∈ eachindex(x)
            # --- random phase 
            ξ = randn(T) * √(pn.σ2)
            # --- Wiener model
            ϕ̄       = ϕ̄ + ξ
            y[n]    = x[n] * exp(1im*ϕ̄)
        end 
        # --- Update Wiener structure 
        pn.ϕ̄ = ϕ̄
        pn.counter += length(x)
    end
end
function addPhaseNoise(x::Union{AbstractVector{Complex{T}},AbstractVector{T}},pn::PhaseNoiseModel) where T
    y = zeros(Complex{T},length(x))
    addPhaseNoise!(y,x,pn)
    return y 
end
function addPhaseNoise!(x::AbstractVector{Complex{T}},pn::PhaseNoiseModel) where T
    addPhaseNoise!(x,x,pn)
end
