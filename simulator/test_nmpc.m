nx = 13;
ny = 13;
nu = 2;
nlobj = nlmpc(nx, ny, nu);
Ts = 0.1;
nlobj.Ts = Ts;
nlobj.PredictionHorizon = 10;
nlobj.ControlHorizon = 5;

nlobj.Model.StateFcn = "vf_open_loop";
%nlobj.Model.IsContinuousTime = false;
%nlobj.Model.NumberOfParameters = 1;
%nlobj.Model.OutputFcn = 'pendulumOutputFcn';
%nlobj.Jacobian.OutputFcn = @(x,u,Ts) [1 0 0 0; 0 0 1 0];

nlobj.Weights.OutputVariables = [3 3];



nlobj.Weights.OutputVariables = [3 3];
nlobj.Weights.ManipulatedVariablesRate = 0.1;
nlobj.OV(1).Min = -10;
nlobj.OV(1).Max = 10;

nlobj.MV.Min = -100;
nlobj.MV.Max = 100;


x0 = [0.1;0.2;-pi/2;0.3];
u0 = 0.4;
validateFcns(nlobj,x0,u0,[],{Ts});




