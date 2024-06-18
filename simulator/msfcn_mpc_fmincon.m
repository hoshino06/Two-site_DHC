function msfcn_mpc_fmincon(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

%   Copyright 2003-2018 The MathWorks, Inc.

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C MEX counterpart: mdlInitializeSizes
%%
function setup(block)

% Register parameters
block.NumDialogPrms  = 7;
sample_time = block.DialogPrm(1).Data;
horizon     = block.DialogPrm(2).Data;

% Register number of ports
block.NumInputPorts  = 4;
block.NumOutputPorts = 3;

% Setup port properties to be inherited or dynamic
%block.SetPreCompInpPortInfoToDynamic;
%block.SetPreCompOutPortInfoToDynamic;

% InputPort(1): reg-d signal
block.InputPort(1).Dimensions  = (horizon+1);
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% InputPort(2): heat ref signal
block.InputPort(2).Dimensions  = 1;
block.InputPort(2).DatatypeID  = 0;  % double
block.InputPort(2).Complexity  = 'Real';
block.InputPort(2).DirectFeedthrough = true;

% InputPort(3): Cuurent state
block.InputPort(3).Dimensions  = 13;
block.InputPort(3).DatatypeID  = 0;  % double
block.InputPort(3).Complexity  = 'Real';
block.InputPort(3).DirectFeedthrough = true;

% InputPort(4): Previously planned inputs
block.InputPort(4).Dimensions  = 2*(horizon); 
block.InputPort(4).DatatypeID  = 0;  % double
block.InputPort(4).Complexity  = 'Real';
block.InputPort(4).DirectFeedthrough = true;

% OutputPort(1): Plannd inputs v[k]
block.OutputPort(1).Dimensions  = 2;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode = 'Sample';

block.OutputPort(2).Dimensions   = 2*(horizon); % for future inputs
block.OutputPort(2).DatatypeID  = 0; % double
block.OutputPort(2).Complexity  = 'Real';
block.OutputPort(2).SamplingMode = 'Sample';

block.OutputPort(3).Dimensions  = 1;
block.OutputPort(3).DatatypeID  = 0; % double
block.OutputPort(3).Complexity  = 'Real';
block.OutputPort(3).SamplingMode = 'Sample';


% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [sample_time, 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
%block.RegBlockMethod('Derivatives', @Derivatives);
%block.RegBlockMethod('Terminate', @Terminate); % Required
block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);

end
%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C MEX counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)

horizon =  block.DialogPrm(2).Data;
block.NumDworks = 1;
  
  block.Dwork(1).Name            = 'v_kminus1';
  block.Dwork(1).Dimensions      = 2*(horizon);
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;
  
end 
%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(~)

end
%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C MEX counterpart: mdlStart
%%
function Start(block)

block.Dwork(1).Data = zeros(1, block.Dwork(1).Dimensions);

end
%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)

tic % calculate time

%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%
Tstp = block.DialogPrm(1).Data; % time step
Tnum = block.DialogPrm(2).Data; % horizon

%%%% Reference trajectory  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z_d = zeros( 9*(Tnum+1), 1); % for k, k+1, ..., k+N
v_d = zeros( 2*Tnum    , 1); % for k, k+1, ..., k+N-1 
s_d = block.InputPort(1).Data;
s_d = [s_d; s_d(Tnum+1)*ones(Tnum,1)];
for i = 0:Tnum 
    y1   = s_d(i+1);
    y1d1 = (s_d(i+2)-s_d(i+1))/Tstp;
    y1d2 = (s_d(i+3)-2*s_d(i+2)+s_d(i+1))/ Tstp^2;
    y1d3 = (s_d(i+4)-3*s_d(i+3)+3*s_d(i+2)-s_d(i+1))/ Tstp^3;
    y1d4 = (s_d(i+5)-4*s_d(i+4)+6*s_d(i+3)-4*s_d(i+2)+s_d(i+1))/ Tstp^4;
    v1   = (s_d(i+6)-5*s_d(i+5)+10*s_d(i+4)-10*s_d(i+3)+5*s_d(i+2)-s_d(i+1))/ Tstp^5;
    
    y2 = block.InputPort(2).Data;
    
    z_k = [[y1; y1d1; y1d2; y1d3; y1d4;]; [y2; 0; 0; 0;]];
    %z_k = [[y1; 0; 0; 0; 0;]; [y2; 0; 0; 0;]];
    
    z_d( i*9+1 :(i+1)*9 ) =  z_k;
    v_d( i+1 ) = v1;
end
%disp(z_d(1:9)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cost fucntion
Qz= block.DialogPrm(3).Data; % weight matrix for state
Rv= block.DialogPrm(4).Data; % weight matrix for input

p1 = 5.0;
p2 = 1.0;
A = blkdiag( ...
    [zeros(4,1) eye(4); -[p1^5, 5*p1^4, 10*p1^3, 10*p1^2, 5*p1] ],...
    [zeros(3,1) eye(3); -[p2^4, 4*p2^3, 6*p2^2, 4*p2] ] ...
    ); 
B = [ ...
     -A*[[1;0;0;0;0]; zeros(4,1)], ...
     -A*[ zeros(5,1); [1;0;0;0]]
    ]; 
expAB00 = expm([A B; zeros(2,9+2)]*Tstp);
F = expAB00(1:9,1:9); 
G = expAB00(1:9,10:11);
Pz = idare(F,G,Qz,Rv,[],[]);

Q = Qz;
for i=1:Tnum-1; Q= blkdiag( Q, Qz ); end 
Q = blkdiag( Q, Pz ); 
R = Rv;
for i=1:Tnum-1; R = blkdiag( R, Rv ); end 

function f = obj(x_k, u_km1, u)
    %disp('------obj ------------')
    zlist = zeros(9*(Tnum+1), 1);
    % k = 0 
    xi_k = coordinate_transformation( x_k ); 
    z_k  = xi_k(1:9);
    zlist(1:9) = z_k;  
    for k = 1:Tnum
        u_k = u(2*k-1:2*k);
        opts = odeset('AbsTol',1e-3,'RelTol',1e-3);
        [~,xlist] = ode45(@(t,y) vf_open_loop(y,u_k), [0,Tstp], x_k,opts);
        x_k = xlist(end,:);
        xi_k = coordinate_transformation( x_k ); 
        z_k  = xi_k(1:9);
        zlist(1+9*k:9+9*k) = z_k; 
    end
    %disp( [zlist, z_d] )
    %disp( (zlist-z_d)'*Q*(zlist-z_d) ) 
    
    ulist = [u_km1; u];
    Mdel = (eye(12) -circshift(eye(12),[0,2]) );
    udel = Mdel(1:10, :)*ulist;

    f = (zlist-z_d)'*Q*(zlist-z_d) + udel'*R*udel;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve optimization problem using fmincon
x_k   = block.InputPort(3).Data; % current state x[k]
u     = block.InputPort(4).Data;
u_km1 = u(1:2);  % input at k-1
u_ig  = [u(3:end); u(end-1:end)]; % initial guess

%options = optimoptions(@quadprog, 'Display', 'none');
%u0 = zeros(10,1);
%disp('==== fmincon ==============================')

%options = optimoptions(@fmincon, 'Display', 'off','OptimalityTolerance',1e-3); original setting
options = optimoptions(@fmincon, 'Display', 'off', ...
                    'OptimalityTolerance',1e-3, ...
                    'StepTolerance', 1e-6, ...
                    'ConstraintTolerance',1e-3);

disp(options)

u = fmincon(@(u) obj(x_k,u_km1, u), u_ig , [],[],[],[],0,1,[],options);

cal_time = toc;

block.OutputPort(1).Data = u(1:2);
block.OutputPort(2).Data = u;
block.OutputPort(3).Data = cal_time;

end
%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlUpdate
%%
function Update(block)

block.Dwork(1).Data = block.OutputPort(2).Data;

end
%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlDerivatives
%%
%function Derivatives(~)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(~)

end
%end Terminate

function SetInputPortSamplingMode(s, port, mode)
s.InputPort(port).SamplingMode = mode;

end


end