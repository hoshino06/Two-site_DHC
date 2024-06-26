# Two-site_DHC

Matlab/simulink implementation for two-site benchmark system for smart district participating in frequency regulation market.
 ([arXiv](https://arxiv.org/abs/2305.07198))

## Model overview

<img src="overview.jpg" />

## Requisite

- MATLAB (tested with MATLAB Version: 9.14.0.2337262 (R2023a) Update 5)
- Simulink (Version 10.7)
- Optimization Toolbox (Version 9.5)
- python (only for plot results)

## How to run model predictive controller 

1. Run simulation with standard NMPC (fmincon)
	```
	cd simulation
	matlab simex1_nmpc.m  #Run simulation
	python simex1_nmpc.py #Plot results
	```

2. Run simulation with proposed NMPC without constraint (Figure5)
	```
	matlab simex1_proposed.m  #Run simulation
	python simex1_proposed.py #Plot results
	```

2. Run simulation with proposed NMPC with pressure constraint (Figure6)
	```
	matlab simex2_constraint.m  #Run simulation
	python simex2_constraint.py #Plot results
	```

2. Run simulation with proposed NMPC with input constraint (Figure8&9)
	```
	matlab simex3_input_const.m #Run simulation
	python simex3_comparison.py #Plot results(Figure8)
	python simex3_refplane.py   #Plot results(Figure9)
	```
