% twosite.m 
clear

%% simulink モデルの呼び出し
addpath('../simulator')
mdl = 'twosite_system_sampled';
open_system(mdl)

%% シミュレーション設定
% サンプリング時間および予測ホライズン
set_param([mdl,'/mpc'], 'Tstep', '2.0')
set_param([mdl,'/mpc'], 'Nhorizon', '5')

% 電力の指令値に関する設定
set_param([mdl,'/power_ref'],'Pnominal', '1.0')
set_param([mdl,'/power_ref'],'ASamplitude','0.4')

% 熱の指令値に関する設定
NominalHref = '1.68667';
set_param([mdl,'/HeatRef'], 'Value', NominalHref)

% MPCの評価関数の重み
Qz = 'blkdiag( 10, eye(4), 10, eye(3) )'; % パラメータは文字列で指定
Rv = '0.01*eye(2)';
set_param([mdl,'/mpc'], 'Qz', Qz)
set_param([mdl,'/mpc'], 'Rv', Rv)
clear Qz Rv

% 圧力に関する制約条件
set_param([mdl,'/mpc'], 'Plim', '[-50, 50]') %kPa

% 入力に関する制約条件
set_param([mdl,'/mpc'], 'u1max', '1.0')
set_param([mdl,'/mpc'], 'u2max', '1.0')
set_param([mdl,'/Saturation'], 'UpperLimit', '[1.0, 1.0]')

% 測定雑音
set_param([mdl,'/noise'], 'Value', '0')

% 計算の時間
set_param(mdl,'StartTime','-180', 'StopTime','60*40')

%% シミュレーションの実行
res = sim(mdl);
T = array2table(res.tout, 'VariableNames',{'time'} );
T = join(T, array2table(res.power,    'VariableNames',{'time','regd','power'}) );
T = join(T, array2table(res.heatflow, 'VariableNames',{'time','heatflow'}) );
T = join(T, array2table(res.pressure, 'VariableNames',{'time','pressure'}) );
writetable(T, 'simex2_constraint_outputs.csv')

T = array2table( ...
    [res.inputs.time, res.inputs.signals.values], 'VariableNames',{'time','in1','in2'} );
T = join(T, array2table( ...
    [res.cal_time.time res.cal_time.signals.values], ...
    'VariableNames',{'time','cal_time'}) );
writetable(T, 'simex2_constraint_inputs_etc.csv')
