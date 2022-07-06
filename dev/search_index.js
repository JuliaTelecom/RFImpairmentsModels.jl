var documenterSearchIndex = {"docs":
[{"location":"base/#Common-functions","page":"Function list","title":"Common functions","text":"","category":"section"},{"location":"base/","page":"Function list","title":"Function list","text":"Modules = [RFImpairmentsModels]\nPages   = [\"RFImpairmentsModels.jl\"]\nOrder   = [:function, :type]\nDepth\t= 1","category":"page"},{"location":"base/#IQ-Mismatch","page":"Function list","title":"IQ Mismatch","text":"","category":"section"},{"location":"base/","page":"Function list","title":"Function list","text":"Modules = [RFImpairmentsModels]\nPages   = [\"IQMismatch.jl\"]\nOrder   = [:function, :type]\nDepth\t= 1","category":"page"},{"location":"base/#RFImpairmentsModels.addIQMismatch-Union{Tuple{T}, Tuple{AbstractArray{Complex{T}, 1}, Any, Any}} where T","page":"Function list","title":"RFImpairmentsModels.addIQMismatch","text":"Apply IQ Mismatch to complex input signal x parametrized by the gain mismtach g (in dB) and the phase mismatch ϕ. The model split the gain in 2 equi-partioned gains and split the phase into equi-partioned phase. [1] Matthias Hesse, Marko Mailand, Hans-Joachim Jentschel, Luc Deneire, Jerome Lebrun. Semi-Blind Cancellation of IQ-Imbalances. IEEE International Conference on Communications, May 2008, Bei- jing, China. hal-00272886v1 There are 3 versions for the function \n\nOne with allocation of the output y = addIQMismatch(x,g,ϕ) or y = addIQMismatch(g,s::IQMismatch)\nOne with mutation of the second input addIQMismatch!(y,x,...)\nOne with in place mutation: addIQMismatch!(x,...). In the latter case the signal is modified with a signal impaired by IQ mismatch \n\n\n\n\n\n","category":"method"},{"location":"base/#RFImpairmentsModels.db_to_linear-Tuple{Any}","page":"Function list","title":"RFImpairmentsModels.db_to_linear","text":"Convert log in linear scale\n\n\n\n\n\n","category":"method"},{"location":"base/#RFImpairmentsModels.deg_to_rad-Tuple{Any}","page":"Function list","title":"RFImpairmentsModels.deg_to_rad","text":"Convert input degree in radians\nrad = degtorad(deg)\n\ndeg : Input, in degree\n\n\n\n\n\n","category":"method"},{"location":"base/#RFImpairmentsModels.initIQMismatch-Tuple{Any, Any}","page":"Function list","title":"RFImpairmentsModels.initIQMismatch","text":"Initiate IQ mismatch model, based on gain imbalance (in dB) and phase imbalance (in radians) \ninitIQMismatch(g,ϕ)\n\ng : gain imbalance, in dB \nϕ : Phase imbalance in radians \n\n\n\n\n\n","category":"method"},{"location":"base/#Carrier-Frequency-Offset","page":"Function list","title":"Carrier Frequency Offset","text":"","category":"section"},{"location":"base/","page":"Function list","title":"Function list","text":"Modules = [RFImpairmentsModels]\nPages   = [\"CarrierFrequencyOffset.jl\"]\nOrder   = [:function, :type]\nDepth\t= 1","category":"page"},{"location":"base/#RFImpairmentsModels.addCFO-Union{Tuple{T}, Tuple{Union{AbstractArray{Complex{T}, 1}, AbstractVector{T}}, Any, Any}, Tuple{Union{AbstractArray{Complex{T}, 1}, AbstractVector{T}}, Any, Any, Any}} where T<:Real","page":"Function list","title":"RFImpairmentsModels.addCFO","text":"Adding Carrier Frequency Offset δ in Hz to the input signal x sampled at frequency fs (In Hz) with initial phase ϕ (default 0)\nThis function does not mutate the input signal. See addCFO! for mutating function. In case you want to add normalized CFO, set the fs to 1. \ny = addCFO(x,δ,fs,ϕ=0) \nInput Parameters \n\nx : Input signal \nδ : Carrier frequency offset [Hz]\nfs : Sampling rate [Hz]\nϕ : Offset phase (Default 0) [Hz]\n\nOutput parameters \n\ny : Signal with CFO\n\nThere are 3 versions \n\nOne with allocation on the output y = addCFO(x,δ,fs,ϕ) or y = addCFO(x,cfo::CFO)\nOne without allocation and mutation of first input : addCFO!(y,x,...)\nOne with in place location of input addCFO!(x,...)\n\n\n\n\n\n","category":"method"},{"location":"base/#RFImpairmentsModels.initCFO","page":"Function list","title":"RFImpairmentsModels.initCFO","text":"Init a Carrier Frequency structure, usefull to call addCFO with scfo \\  scfo = addCFO(f,fs,ϕ) Input Parameters \n\nδ : Carrier frequency offset [Hz]\nfs : Sampling rate [Hz]\nϕ : Offset phase (Default 0) [Hz]\n\nOutput parameters \n\ns_cfo : CFO structure (CFO)\n\n\n\n\n\n","category":"function"},{"location":"base/#Phase-Noise","page":"Function list","title":"Phase Noise","text":"","category":"section"},{"location":"base/","page":"Function list","title":"Function list","text":"Modules = [RFImpairmentsModels]\nPages   = [\"PhaseNoise.jl\"]\nOrder   = [:function, :type]\nDepth\t= 1","category":"page"},{"location":"base/#RFImpairmentsModels.addPhaseNoise!-Union{Tuple{T}, Tuple{AbstractArray{Complex{T}, 1}, Any, RFImpairmentsModels.PhaseNoiseModel}} where T","page":"Function list","title":"RFImpairmentsModels.addPhaseNoise!","text":"Add phase noise parametrized by pn to the input signal x There are 3 versions \n\nOne with allocation of the output y = addPhaseNoise(x,pn)\nOne with in place mutation of the first vector addPhaseNoise!(y,x,pn)\nOne with in place mutation of the input vector addPhaseNoise!(x,pn)\n\n\n\n\n\n","category":"method"},{"location":"base/#RFImpairmentsModels.initPhaseNoise-Tuple{Symbol}","page":"Function list","title":"RFImpairmentsModels.initPhaseNoise","text":"Instantiate a phase noise model, with specific model and associated parameters\n\nWiener => Wiener phase noise parametrized by the normalized state noise variance \nNone  => No phase noise. Signal will not be impaired when addPhaseNoise will be used\n\n\n\n\n\n","category":"method"},{"location":"base/#Non-linear-PA","page":"Function list","title":"Non linear PA","text":"","category":"section"},{"location":"base/","page":"Function list","title":"Function list","text":"Modules = [RFImpairmentsModels]\nPages   = [\"NonLinearPA.jl\"]\nOrder   = [:function, :type]\nDepth\t= 1","category":"page"},{"location":"base/#RFImpairmentsModels.addNonLinearPA-Tuple{AbstractVector{T} where T, RFImpairmentsModels.PowerAmplifier}","page":"Function list","title":"RFImpairmentsModels.addNonLinearPA","text":"Apply Power Amplifier non linearity to input signal x following non linear PA model defined in structure pa There are 3 version \n\nOne with allocation of the output y = addNonLinearPA(x,pa)\nOne with in place mutation of the first input addNonLinearPA!(y,x,pa)\nOne with in place mutation of the input signal addNonLinearPA!(x,pa)\n\n\n\n\n\n","category":"method"},{"location":"base/#RFImpairmentsModels.initNonLinearPA-Tuple{Symbol}","page":"Function list","title":"RFImpairmentsModels.initNonLinearPA","text":"Instantiate a non linear PA model, based on a given model and is associated parameters.\n\nRapp PA model [:Rapp]\n\nFirst model is Rapp model [1] that is function of a certain backOff power and smoothness parameter (also called the knee parameter). Rapp non linear power amplifier model is only a AM/AM distortion model and do not affect the phase. It is also possible to specify the theoretical input power value (i.e E[|x[n]|²]). Indded the saturation is defined as a backoff with respect to the input average power. It the power is not specified, the estimated power is first calculated from the time sequence (with 1/N ∑ | x[n]|²). It may lead to bias especially for signal with strong peak to average power ratio. In this case it can be usefull to compute the theoretical power first (and give to this function with power keyword) to have a constant saturation value. \n[1] = C. Rapp. Effects of HPA-nonlinearity on a 4-DPSK/OFDM-signal for a digital sound broadcasting signal. In P. S. Weltevreden, editor, ESA Special Publication, volume 332 of ESA Special Publication, Oct. 1991.\n\n\nSaleh Model\n\nA second model is the Saleh model that both affect the AM/AM distortion and the AM/PM distortion. The model is parametrized by 4 parameters αAM, βAM, αPM and βPM.  [2] = A. A. M. Saleh. Frequency-independent and frequency-dependent nonlinear models of TWT amplifiers. 29(11):1715–1720.\n\nGhorbani model\n\nA third model is the Ghorbani model that also defines an AM/AM distortion and the AM/PM distortion through a set of 8 parameters, a1,a2,a3,a4 (for the amplitude) and b1,b2,b3,b4 for the phase distortion.\n\n[3] = A. Ghorbani and M. Sheikhan. The effect of solid state power amplifiers (SSPAs) nonlinearities on MPSK and M-QAM signal transmission. In Digital Processing of Signals in Communications, 1991., Sixth International Conference On, pages 193–197\n\nNone model\n\nPure linear amplification, usefull to be sure no impairments is applied\n\ninitNonLinearPA(:Rapp;power=-1,backOff=0,smoothness=0)\n- power     : For Rapp model. Theoretical power for constant saturation level. If -1, empirical power is used (default -1)\n\nbackOff   : For Rapp model. BackOff value, in dB (default 0)\nsmoothness: For Rapp model. Smoothness value (typically between 1 and 10)(default 0)\nα_AM      : For Saleh model. α parameter for AM distortion (default 0)\nβ_AM      : For Saleh model. β parameter for AM distortion (default 0)\nα_PM      : For Saleh model. α parameter for PM distortion (default 0)\nβ_PM      : For Saleh model. β parameter for PM distortion (default 0)\na1,a2,a3,a4 : For Ghorbani model. Parameters for AM/AM distortion (default all at 0)\nb1,b2,b3,b4 : For Ghorbbni model. Pbrbmeters for AM/PM distortion (default all at 0)\nlinearGain : For Linear PA model. Applied gain (default 1)\n\n\n\n\n\n","category":"method"},{"location":"#RFImpairmentsModels","page":"Introduction","title":"RFImpairmentsModels","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"(Image: )","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"This Julia package aims to propose digital baseband models for Radio Frequency (RF) impairments. These models are useful for Physical layer design  as a digital receiver chain requires often digital compensation of the impairments from both the transmitter and the receiver sides. We propose state of the art models for different RF impairments models ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"I/Q mismatch (also called IQ imbalance) induced by the local oscillator \nCarrier Frequency Offset, induced by the difference between the Tx oscillator and the Rx oscillators \nPhase noise, induced by the Tx (or Rx) local oscillator\nNon linear Power amplifier models, with -for the moment- parametric models and that models the distortion induced by the power amplifier of the transmitter stage. ","category":"page"}]
}