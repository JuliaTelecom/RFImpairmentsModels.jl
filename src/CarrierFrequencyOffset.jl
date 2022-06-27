# ----------------------------------------------------
# --- Carrier Frequency Offset 
# ---------------------------------------------------- 
struct CFO
    f::Float64  # Carrier frequecy Offset in Hz 
    fs::Float64 # Sampling frequency in Hz 
    ϕ::Float64  # Offset phase in Hz
    ω::Float64  # Normalized pulsation 
end 


function initCFO(f,fs,ϕ=0)
    return CFO(f,fs,ϕ,f/fs)
end

"""
Adding Carrier Frequency Offset δ in Hz to the input signal x sampled at frequency fs (In Hz) with initial phase ϕ (default 0)\\
This function does not mutate the input signal. See addCFO! for mutating function.
In case you want to add normalized CFO, set the fs to 1. \\
y = addCFO(x,delta,fs) \\
Input Parameters 
- x : Input signal 
- δ : Carrier frequency offset [Hz]
- fs : Sampling rate [Hz]
- ϕ : Offset phase (Default 0) [Hz]
Output parameters 
- y : Signal with CFO
There are 3 versions 
- One with allocation on the output y = addCFO(x,...)
- One without allocation and mutation of first input : addCFO!(y,x,...)
- One with in place location of input addCFO!(x,...)
""" 
function addCFO(x::Union{AbstractVector{Complex{T}},AbstractVector{T}},δ,fs,ϕ=0) where {T<:Real}
    y = zeros(Complex{T},length(x))
    addCFO!(y,x,δ,fs,ϕ)
    return y
end

function addCFO!(y::AbstractVector{Complex{T}},x::AbstractVector,δ::Number,fs::Number,ϕ=0) where {T<:Real}
    # --- Basic array check 
    @assert length(x) == length(y) "Input and output should have same length (here input x is $(length(x)) and pre-allocated output has size $(length(y))"
    # --- CFO pulsation 
    ω = δ / fs 
    # --- Adding CFO 
    @inbounds @simd for n ∈ eachindex(x)
        y[n] = x[n] * Complex{T}(exp(2im*π*ω*( (n-1) + ϕ)))
    end
end
function addCFO!(x::AbstractVector{Complex{T}},δ::Number,fs::Number,ϕ=0) where {T<:Real}
    addCFO!(x,x,δ,fs,ϕ)
end


function addCFO(x::Union{AbstractVector{Complex{T}},AbstractVector{T}},cfo::CFO) where  {T<:Real}
    y = zeros(Complex{T},length(x))
    addCFO!(y,x,cfo)
    return y
end
function addCFO!(y::AbstractVector,x::AbstractVector,cfo::CFO)
    addCFO!(y,x,cfo.f,cfo.fs,cfo.ϕ)
end
function addCFO!(x::AbstractVector,cfo::CFO)
    addCFO!(x,x,cfo.f,cfo.fs,cfo.ϕ)
end

