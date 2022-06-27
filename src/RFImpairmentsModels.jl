module RFImpairmentsModels

# ----------------------------------------------------
# --- Dependencies
# ---------------------------------------------------- 
using Random            # Seeds 
using UnPack            # Easy pack // unpack
using Statistics        # Compute power 

# ----------------------------------------------------
# --- IQ Mismatch 
# ---------------------------------------------------- 
include("IQMismatch.jl")
export initIQMismatch
export addIQMismatch, addIQMismatch!

# ----------------------------------------------------
# --- Phase noise 
# ---------------------------------------------------- 
include("PhaseNoise.jl")
export initPhaseNoise 
export addPhaseNoise, addPhaseNoise!


# ----------------------------------------------------
# --- Carrier frequency Offset 
# ---------------------------------------------------- 
include("CarrierFrequencyOffset.jl")
export initCFO
export addCFO, addCFO!


# ----------------------------------------------------
# --- Non linear PA
# ---------------------------------------------------- 
include("NonLinearPA.jl")
export initNonLinearPA
export addNonLinearPA, addNonLinearPA!


end


