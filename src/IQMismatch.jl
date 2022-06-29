# ----------------------------------------------------
# --- IQ Mismatch model 
# ---------------------------------------------------- 
struct IQMismatch 
    g::Float64
    ϕ::Float64
    g1::Float64
    g2::Float64
    g3::Float64
    g4::Float64
end

""" Initiate IQ mismatch model, based on gain imbalance (in dB) and phase imbalance (in radians) \\
initIQMismatch(g,ϕ)
- g : gain imbalance, in dB 
- ϕ : Phase imbalance in radians 
"""
function initIQMismatch(g,ϕ)
    # --- Gain managment 
    glin = db_to_linear(g)
    gI,gQ = 1-glin/2,1+glin/2
    # Split phase for I and Q paths
    ϕI,ϕQ = ϕ/2,ϕ/2
    # Matrix (tuple for sp44d)
    g1,g2,g3,g4 = (gI*cos(ϕI) , gI*sin(ϕI) , -gQ*sin(ϕQ) , gQ * cos(ϕQ))
    return IQMismatch(g,ϕ,g1,g2,g3,g4)
end

""" Convert log in linear scale
"""
function db_to_linear(gdb) 
    if gdb == -Inf 
        return 0
    else 
        return 10^(gdb/10)
    end
end


""" Convert input degree in radians\\
rad = deg_to_rad(deg)
- deg : Input, in degree
""" 
deg_to_rad(deg) = π * deg / 180

""" Apply IQ Mismatch to complex input signal x parametrized by the gain mismtach g (in dB) and the phase mismatch ϕ.
The model split the gain in 2 equi-partioned gains and split the phase into equi-partioned phase.
[1] Matthias Hesse, Marko Mailand, Hans-Joachim Jentschel, Luc Deneire, Jerome Lebrun. Semi-Blind Cancellation of IQ-Imbalances. IEEE International Conference on Communications, May 2008, Bei- jing, China. hal-00272886v1
There are 3 versions for the function 
- One with allocation of the output y = addIQMismatch(x,g,ϕ) or y = addIQMismatch(g,s::IQMismatch)
- One with mutation of the second input addIQMismatch!(y,x,...)
- One with in place mutation: addIQMismatch!(x,...). In the latter case the signal is modified with a signal impaired by IQ mismatch 
"""
function addIQMismatch(x::AbstractVector{Complex{T}},g,ϕ) where T 
    # --- Init vector 
    y = similar(x)
    # --- In place mismatch
    addIQMismatch!(y,x,g,ϕ)
    return y
end 
function addIQMismatch!(y::AbstractVector{Complex{T}},x::AbstractVector{Complex{T}},g,ϕ) where T
    iqMismatch = initIQMismatch(g,ϕ)
    addIQMismatch!(y,x,iqMismatch::IQMismatch)
end
# In place Mismatch
function addIQMismatch!(x,g,ϕ)
    addIQMismatch!(x,x,g,ϕ)
end

# ----------------------------------------------------
# Using IQMismatch structure 

function addIQMismatch(x::AbstractVector,iqMismatch::IQMismatch)
    y = similar(x)
    addIQMismatch!(y,x,iqMismatch)
    return y 
end
function addIQMismatch!(y::AbstractVector,x::AbstractVector,iqMismatch::IQMismatch)
    @unpack g1,g2,g3,g4 = iqMismatch
    # Apply mismatch
    @inbounds @simd for n ∈ eachindex(x)
        # --- Mixtcure 
        (x_re,x_im) = (real(x[n]),imag(x[n]))
        y[n] = g1*x_re + g2*x_im +1im*( g3*x_re + g4*x_im  )
    end
end
function addIQMismatch!(x::AbstractVector,pn::IQMismatch)
    addIQMismatch!(x,x,pn)
end


