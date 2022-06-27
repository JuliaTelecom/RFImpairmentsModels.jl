# RFImpairmentsModels

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliatelecom.github.io/RFImpairmentsModels.jl/dev/index.html)

This Julia package aims to propose digital baseband models for Radio Frequency (RF) impairments. These models are useful for Physical layer design  as a digital receiver chain requires often digital compensation of the impairments from both the transmitter and the receiver sides.
We propose state of the art models for different RF impairments models 
- I/Q mismatch (also called IQ imbalance) induced by the local oscillator 
- Carrier Frequency Offset, induced by the difference between the Tx oscillator and the Rx oscillators 
- Phase noise, induced by the Tx (or Rx) local oscillator
- Non linear Power amplifier models, with -for the moment- parametric models and that models the distortion induced by the power amplifier of the transmitter stage. 


