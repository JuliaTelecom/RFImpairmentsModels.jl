# ----------------------------------------------------
# --- Power amplifier 
# ---------------------------------------------------- 

abstract type PowerAmplifier end 

# Rapp type 
struct Rapp_PowerAmplier <: PowerAmplifier
    name::Symbol
    power::Float64              # Theoretical power: -1 use empirical power measure
    backOff::Float64            # Backoff for saturation 
    smoothness::Float64         # Smoothness
    saturation::Float64 
end

# Saleh type 
struct Saleh_PowerAmplifier <: PowerAmplifier
    name::Symbol
    α_AM::Float64
    β_AM::Float64
    α_PM::Float64
    β_PM::Float64
end

# Ghorbani type 
struct Ghorbani_PowerAmplifier <: PowerAmplifier 
    name::Symbol
    a1::Float64
    a2::Float64
    a3::Float64
    a4::Float64
    b1::Float64
    b2::Float64
    b3::Float64
    b4::Float64
end


struct Linear_PowerAmplifier <: PowerAmplifier
    name::Symbol
    linearGain::Float64
end

""" 
Instantiate a non linear PA model, based on a given `model` and is associated parameters.
# Rapp PA model [:Rapp]
First model is Rapp model [1] that is function of a certain `backOff` power and `smoothness` parameter (also called the knee parameter). Rapp non linear power amplifier model is only a AM/AM distortion model and do not affect the phase.
It is also possible to specify the theoretical input power value (i.e E[|x[n]|²]). Indded the saturation is defined as a backoff with respect to the input average power. It the power is not specified, the estimated power is first calculated from the time sequence (with 1/N ∑ | x[n]|²). It may lead to bias especially for signal with strong peak to average power ratio. In this case it can be usefull to compute the theoretical power first (and give to this function with `power` keyword) to have a constant saturation value. \\
[1] = C. Rapp. Effects of HPA-nonlinearity on a 4-DPSK/OFDM-signal for a digital sound broadcasting signal. In P. S. Weltevreden, editor, ESA Special Publication, volume 332 of ESA Special Publication, Oct. 1991.\\

# Saleh Model
A second model is the Saleh model that both affect the AM/AM distortion and the AM/PM distortion. The model is parametrized by 4 parameters α_AM, β_AM, α_PM and β_PM. 
[2] = A. A. M. Saleh. Frequency-independent and frequency-dependent nonlinear models of TWT amplifiers. 29(11):1715–1720.

# Ghorbani model
A third model is the Ghorbani model that also defines an AM/AM distortion and the AM/PM distortion through a set of 8 parameters, a1,a2,a3,a4 (for the amplitude) and b1,b2,b3,b4 for the phase distortion.

[3] = A. Ghorbani and M. Sheikhan. The effect of solid state power amplifiers (SSPAs) nonlinearities on MPSK and M-QAM signal transmission. In Digital Processing of Signals in Communications, 1991., Sixth International Conference On, pages 193–197

# None model 
Pure linear amplification, usefull to be sure no impairments is applied

initNonLinearPA(:Rapp;power=-1,backOff=0,smoothness=0)\\
- power     : For Rapp model. Theoretical power for constant saturation level. If -1, empirical power is used (default -1)
- backOff   : For Rapp model. BackOff value, in dB (default 0)
- smoothness: For Rapp model. Smoothness value (typically between 1 and 10)(default 0)
- α_AM      : For Saleh model. α parameter for AM distortion (default 0)
- β_AM      : For Saleh model. β parameter for AM distortion (default 0)
- α_PM      : For Saleh model. α parameter for PM distortion (default 0)
- β_PM      : For Saleh model. β parameter for PM distortion (default 0)
- a1,a2,a3,a4 : For Ghorbani model. Parameters for AM/AM distortion (default all at 0)
- b1,b2,b3,b4 : For Ghorbbni model. Pbrbmeters for AM/PM distortion (default all at 0)
- linearGain : For Linear PA model. Applied gain (default 1)
"""
function initNonLinearPA(model::Symbol;power=-1,backOff=0,smoothness=0,α_AM=1,β_AM=0,α_PM=0,β_PM=0,a1=0,a2=0,a3=0,a4=0,b1=0,b2=0,b3=0,b4=0,linearGain=1)
    if model == :Rapp
        # ----------------------------------------------------
        # --- Rapp model 
        # ---------------------------------------------------- 
        saturation = 10^(backOff/20)
        pa = Rapp_PowerAmplier(model,power,backOff,smoothness,saturation)
    elseif model == :Saleh
        pa = Saleh_PowerAmplifier(model,α_AM,β_AM,α_PM,β_PM)
    elseif model == :Ghorbani
        pa = Ghorbani_PowerAmplifier(model,a1,a2,a3,a4,b1,b2,b3,b4)
    elseif model == :Linear
        pa = Linear_PowerAmplifier(model,linearGain)
    else 
        @error "Unknown Power Amplifier model"
    end
    return pa
end


""" Apply Power Amplifier non linearity to input signal `x` following non linear PA model defined in structure `pa`
There are 3 version 
- One with allocation of the output y = addNonLinearPA(x,pa)
- One with in place mutation of the first input addNonLinearPA!(y,x,pa)
- One with in place mutation of the input signal addNonLinearPA!(x,pa)
"""
function addNonLinearPA(x::AbstractVector,pa::PowerAmplifier)
    y = similar(x)
    addNonLinearPA!(y,x,pa)
    return y
end
function addNonLinearPA!(x::AbstractVector,pa::PowerAmplifier)
    addNonLinearPA!(x,x,pa)
end


function addNonLinearPA!(y::AbstractVector,x::AbstractVector,pa::PowerAmplifier)
    if pa isa Rapp_PowerAmplier
        # ----------------------------------------------------
        # --- Apply Rapp model
        # ---------------------------------------------------- 
       if pa.power == -1 
           # We do not have provided the theoretical power for the input, we need to estimate the input power to ensure saturation is done correctly 
           power = mean(abs2.(x))
       end
       vSat     = sqrt(power) * pa.saturation
       p        = pa.smoothness
       denom    = (1 .+ abs2.(x).^p / (vSat^2p) ) .^ (1/(2*p))
       y        .= x./denom
   elseif pa isa Saleh_PowerAmplifier
       @unpack α_AM, β_AM, α_PM, β_PM = pa
       for n ∈ eachindex(x)
           # Input 
           A = abs(x[n])
           ϕ = angle(x[n])
           # Ouptut 
           g = α_AM * A     / (1 + β_AM * A^2)
           Ψ = α_PM * A^2   / (1 + β_PM * A^2)
           # Setfield 
           y[n] = g * exp(1im*(ϕ+Ψ))
       end
   elseif pa isa Ghorbani_PowerAmplifier
       # AM/AM 
       @unpack a1,a2,a3,a4 = pa 
       # AM/PM 
       @unpack b1,b2,b3,b4 = pa 
       for n ∈ eachindex(x)
           # Input 
           A = abs(x[n])
           ϕ = angle(x[n])
           # Ouptut 
           g = (a1 * A^a2)/(1+a3*A^a2) + a4 * A
           Ψ = (b1 * A^b2)/(1+b3*A^a2) + b4 * A
           # Setfield 
           y[n] = g * exp(1im*(ϕ+Ψ))
       end
   elseif pa isa Linear_PowerAmplifier
       # Simply copy input 
       for n ∈ eachindex(x)
           y[n] = x[n]
       end
   end
end
