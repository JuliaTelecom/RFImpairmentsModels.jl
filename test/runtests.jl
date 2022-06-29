using RFImpairmentsModels
using Test
using Statistics 
using DSP

@testset "IQ mismatch" begin
    # Write your tests here.
    N = 2048
    x = randn(ComplexF64,N)
    # --- Unity transform 
    y = addIQMismatch(x,-Inf,0)
    @test y isa Vector{ComplexF64}
    @test length(y) === length(x)
    @test y == x # model is 0, y == x 
    # 
    y = addIQMismatch(x,0,0)
    @test y isa Vector{ComplexF64}
    @test length(y) === length(x)
    @test y == 1/2*real(x)+3im/2*imag(x) # model is 0, y == x 

    # In place 
    x2 = deepcopy(x)
    addIQMismatch!(x,-Inf,0)
    @test x isa Vector{ComplexF64}
    @test all(x .== x2)

    # Using struct 
    iqMismatch = initIQMismatch(-Inf,0)
    addIQMismatch!(x,iqMismatch)
end


@testset "Phase Noise" begin 
    # --- Wiener phase noise 
    pn = initPhaseNoise(:Wiener;seed=1234,σ2=0)
    x = randn(Float64,512) 
    y = addPhaseNoise(x,pn)
    @test y isa Vector{ComplexF64} 
    @test all(real.(y) .== x)
    x = ones(32768)
    y = zeros(ComplexF64,length(x))
    for σ2 in [1e-2;1e-3;1e-4;1e-5;1e-6;1e-7]
        pn = initPhaseNoise(:Wiener;seed=1234,σ2)
        addPhaseNoise!(y,x,pn)
        d = diff(unwrap(angle.(y)))
        @test isapprox(sqrt(var(d)), sqrt(σ2);atol=1e-3)
    end
    addPhaseNoise!(y,pn)
    @test y isa Vector{ComplexF64}
    # No phase noise model 
    pn = initPhaseNoise(:None;seed=1234,σ2=0)
    x = randn(Float64,512) 
    y = addPhaseNoise(x,pn)
    @test x == y


end

@testset "Testing addCFO.jl..." begin
    # We check with array of ones, to be sure rotation is Ok
    x = ones(2048)
    y = addCFO(x,0,1,0)
    @test length(x) == length(y)
    @test all(x .== y)
    addCFO!(y,x,0,1,0)
    @test all(x .== y)

    # Check it works with complex input
    x = randn(ComplexF64,1024)
    y = addCFO(x,0,1,0)

    # Check that F32 is not promoted to F64
    x2 = randn(ComplexF32,1024)
    y = addCFO(x2,100,1e3,0)
    @test y isa Vector{ComplexF32}


    # Check that CFO is applied
    y = addCFO(x,100,1e3)
    @test y[1] == x[1]
    @test y[2] == x[2] * exp(2im*π*100/1e3)
    @test y[1024] == x[1024] * exp(2im*π*1023*100/1e3)

    cfo = initCFO(100,1e3)
    y = addCFO(x,cfo)
    @test y[1] == x[1]
    @test y[2] == x[2] * exp(2im*π*100/1e3)
    @test y[1024] == x[1024] * exp(2im*π*1023*100/1e3)

    addCFO!(y,cfo)
    @test y isa Vector{ComplexF64}



end
