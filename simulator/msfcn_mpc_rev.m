function msfcn_mpc_rev(block)
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
block.NumDialogPrms     = 7;
sample_time = block.DialogPrm(1).Data;
horizon     = block.DialogPrm(2).Data;

% Register number of ports
block.NumInputPorts  = 4;
block.NumOutputPorts = 2;

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
block.InputPort(4).Dimensions  = 2*(horizon-1); 
block.InputPort(4).DatatypeID  = 0;  % double
block.InputPort(4).Complexity  = 'Real';
block.InputPort(4).DirectFeedthrough = true;

% OutputPort(1): Plannd inputs v[k]
block.OutputPort(1).Dimensions  = 2;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode = 'Sample';

block.OutputPort(2).Dimensions   = 2*(horizon-1); % for future inputs
block.OutputPort(2).DatatypeID  = 0; % double
block.OutputPort(2).Complexity  = 'Real';
block.OutputPort(2).SamplingMode = 'Sample';


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
  block.Dwork(1).Dimensions      = 2*(horizon-1);
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;
  
  
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


%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)

%%%% parameters and values at step k %%%%%%%%%%%%%%%%%%%%%%%
Tstp = block.DialogPrm(1).Data; % time step
Tnum = block.DialogPrm(2).Data; % horizon

x =  block.InputPort(3).Data; %disp(x')
v =  block.InputPort(4).Data;
v =  [v; v(end-1:end)];       % planned input

%%% Prediction model for z %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% linearized system
A = blkdiag( [zeros(4,1) eye(4); zeros(1,5)], [zeros(3,1) eye(3); zeros(1,4)]); 
B = [ [zeros(4,1); 1; zeros(4,1)] [zeros(5,1); zeros(3,1); 1]]; 
% discritization: z(k+1)=F*z(k)+G*z(k)
expAB00 = expm([A B; zeros(2,9+2)]*Tstp);
F = expAB00(1:9,1:9); 
G = expAB00(1:9,10:11);
% matrices for prediction: [z(k+N); ...; z(k+1)] = FF*z(k) + FG*[u(k+N-1); ...; u(k)]
FF = zeros( 9*(Tnum+1), 9 );  FF(1:9,1:9) = eye(9);
FG = zeros( 9*(Tnum+1), Tnum*2 );
for t = 1:Tnum
    FF(t*9+1:(t+1)*9, 1:9) = F^t;
    for i = 1:t
        FG(9*t+1:9*(t+1), 2*i-1:2*i) = F^(t-i) * G;
    end
end

%%% Prediction model for z_eta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization of nominal trajectory (planned at the previous step)
x_bar     = zeros(13,Tnum+1); 
z_bar     = zeros(9, Tnum+1);  
z_eta_bar = zeros(4, Tnum+1);
% initialization of matrices for linearized system
% z_eta(k+1) = F_z*z(k) + F_eta*z_eta(k) + F_v*v[k]
F_z   = zeros(4,9,Tnum);      
F_eta = zeros(4,4,Tnum);
z_eta_nom = zeros(4, Tnum);
F_v   = zeros(4,2,Tnum);

% solve variational equation for Linearization
if x(1) == 0.23 % at initial step
        % avoid solving variational equation at initial step
        % since there is no nominal trajectory
else
    for i = 1:5 %Tnum % for k, k+1, k+2, ..., k+Tnum-1

        % initial value for variational equation at i=1
        if i == 1
            x_k = x; % x is the current state given by the input of the block
            x_bar(:,1) = x_k;
            [z_bar(:,1), z_eta_bar(:,1)] = coordinate_transformation(x); 
        end
        
        % solve variational equation
        v_k = v( 2*i-1 : 2*i)';
        [~,y] = ode45(@(t,y) variational_equation(0,y,v_k), [0 Tstp], [x_k; reshape(eye(15), [15*15,1])] );
        y = y(end, :); 
        
        % save nominal trajectory
        x_k =  y(1:13)'; %disp(x');
        x_bar(:,i+1) = x_k;
        [z_bar(:,i+1), z_eta_bar(:,i+1)] = coordinate_transformation(x_k);
        
        % save matrices for the linearized system 
        Phi = reshape( y(13+1:end), [15,15]);
        F_z_i   = Phi(9+1:9+4, 1:9);
        F_eta_i = Phi(9+1:9+4, 9+1:9+4);
        F_v_i   = Phi(9+1:9+4, 13+1:13+2);
        F_z(:,:,i)   = F_z_i;
        F_eta(:,:,i) = F_eta_i;
        F_v(:,:,i)   = F_v_i;

        % save "z_eta_nom" used for prediction
        z_eta_nom(:,i) = z_eta_bar(:,i+1) - F_eta_i * z_eta_bar(:,i) - F_z_i * z_bar(:,i) - F_v_i * v(2*i-1:2*i);  
        
    end
end
%eta_bar = z_eta_bar

% matrices for prediction (to represent z and z_eta by v)
FF_eta = zeros( 4*(Tnum+1), 4 ); FF_eta(1:4, :) = eye(4);
FG_z = zeros( 4*(Tnum+1), 9*(Tnum+1) );
FG_v   = zeros( 4*(Tnum+1), 2*Tnum );
ZZ_eta_bar = zeros( 4*(Tnum+1), 1);
for k = 1:Tnum % 行ごとのループ 
    FF_eta(4*k+1:4*k+4, :) = F_eta(:,:,k) * FF_eta(4*k-3:4*k, :);
end
for m = 1:Tnum % 列ごとのループ
    FG_z(4*m+1:4*m+4, 9*m-8:9*m) = F_z(:,:,m);
    FG_v(4*m+1:4*m+4, 2*m-1:2*m) = F_v(:,:,m);
    for k = m+1:Tnum 
        FG_z(4*k+1:4*k+4, 9*m-8:9*m) = F_eta(:,:,k) * FG_z(4*k-3:4*k, 9*m-8:9*m);   
        FG_v(4*k+1:4*k+4, 2*m-1:2*m) = F_eta(:,:,k) * FG_v(4*k-3:4*k, 2*m-1:2*m); 
    end
end
for k= 1:Tnum % 行ごとのループ
   ZZ_eta_bar(4*k+1:4*k+4) = z_eta_nom(:,k) + F_eta(:,:,k) * ZZ_eta_bar(4*k-3:4*k);  
end
%clear z_bar z_eta_bar F_z F_eta z_eta_nom 

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
%%%% Formulation of Quadratic Program %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cost fucntion
x_k  = block.InputPort(3).Data; % current state x[k]
xi_k = coordinate_transformation(x_k); 
z_k  = xi_k(1:9);

Qz= block.DialogPrm(3).Data; % weight matrix for state
Rv= block.DialogPrm(4).Data; % weight matrix for input
%Qz = blkdiag( eye(5), 0.01, 100*eye(3) );
%Rv = eye(2);
Pz = idare(F,G,Qz,Rv,[],[]);

Q = Qz;
for i=1:Tnum-1; Q= blkdiag( Q, Qz ); end 
Q = blkdiag( Q, Pz ); 

%R = eye( 2*Tnum );
R = Rv;
for i=1:Tnum-1; R = blkdiag( R, Rv ); end 

H = 2 * ( FG'* Q * FG + R ); 
H = (H+H')/2; % to ensure symmetricity of H
f = 2 * (FF * z_k - z_d)' * Q * FG + 2* v_d' * R;
clear Q R

% constraints
if x(1) == 0.23 % at initial step
        % avoid setting constraints at initial step
   A = []; b = [];
else
    %%% constraints on z_eta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A_eta_cons = zeros( 2* Tnum, 4*(Tnum+1)); 
    b_eta_cons = zeros( 2* Tnum, 1); 
    for k = 1:Tnum
       plim = block.DialogPrm(5).Data;
       pmin = plim(1); pmax = plim(2);
       % upper bound
       A_eta_cons(k, 4*k+1:4*k+4) = [0, 0, 0, 1];
       b_eta_cons(k) = pmax*1000 / 4062.5 * 2  ;  % +50 kPa
       % lower bound
       A_eta_cons(k+Tnum, 4*k+1:4*k+4) = -[0, 0, 0, 1];
       b_eta_cons(k+Tnum) = -pmin*1000 / 4062.5 * 2  ; % -10 kPa  
    end 
    [z_k, z_eta_k] = coordinate_transformation(x);
    A_eta = A_eta_cons * ( FG_z * FG + FG_v );
    b_eta = b_eta_cons - A_eta_cons * ( FF_eta * z_eta_k + FG_z * FF * z_k + ZZ_eta_bar );
    %reshape( FG_z * FG * v + FG_v * v + FF_eta * z_eta_k + FG_z * FF * z_k + ZZ_eta_bar, [4,Tnum+1])

    %%% constraints on steady flow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A_flow_cons = zeros( 1 * Tnum, 9*(Tnum+1)); 
    b_flow_cons = zeros( 1 * Tnum, 1); 
    for k = 1:Tnum
        % upper bound for u1
       u1max = block.DialogPrm(6).Data;
       [slope, intercept] = steady_flow_constraint(u1max, nan); %上限0.9
       A_flow_cons(k, 9*k+1:9*k+9) = [-slope,0,0,0,0, 1,0,0,0];
       b_flow_cons(k) = intercept; 
       % upper bound for u2
       u2max = block.DialogPrm(7).Data;
       [slope, intercept] = steady_flow_constraint(nan, u2max); %上限0.9
       A_flow_cons(k+Tnum, 9*k+1:9*k+9) = [slope,0,0,0,0, -1,0,0,0];
       b_flow_cons(k+Tnum) = -intercept; 
 
    end 
    A_flow = A_flow_cons * FG;
    b_flow = b_flow_cons - A_flow_cons * FF * z_k;
    
    %%% matrices A and b for constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    A = [A_eta; A_flow];
    b = [b_eta; b_flow]; 
   
end % end of if

% solve QP using quadprog
options = optimoptions(@quadprog, 'Display', 'none');
v = quadprog(H,f,A,b, [],[], [],[], [], options);
%u = -decoupling_matrix(x) \ (decoupling_shift_term(x) - v(1:2))
    
block.OutputPort(1).Data = v(1:2);
block.OutputPort(2).Data = v(3:end);


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

%end Terminate

function SetInputPortSamplingMode(s, port, mode)
s.InputPort(port).SamplingMode = mode;
