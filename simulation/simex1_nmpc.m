% twosite.m 
clear

%% simulink モデルの呼び出し
addpath('../simulator')
mdl = 'twosite_system_nmpc';
open_system(mdl)
%load_system(mdl) 


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
Qz = 'blkdiag( 500, eye(4), 500, eye(3) )'; % パラメータは文字列で指定
Rv = '10*eye(2)';
set_param([mdl,'/mpc'], 'Qz', Qz)
set_param([mdl,'/mpc'], 'Rv', Rv)
clear Qz Rv

% 圧力に関する制約条件
set_param([mdl,'/mpc'], 'Plim', '[-200, 200]') %kPa

% 入力に関する制約条件
set_param([mdl,'/mpc'], 'u1max', '1.0')
set_param([mdl,'/mpc'], 'u2max', '1.0')

% 測定雑音
set_param([mdl,'/noise'], 'Value', '0')

% 計算の時間
set_param(mdl,'StartTime','-30', 'StopTime','60*40') 

%% シミュレーションの実行
res = sim(mdl);
T = array2table(res.power, 'VariableNames',{'time','regd','power'});
T = join(T, array2table(res.heatflow, 'VariableNames',{'time','heatflow'}) );
T = join(T, array2table(res.pressure, 'VariableNames',{'time','pressure'}) );
writetable(T, 'simex1_nmpc_outputs_st1e-6.csv')

T = array2table( ...
    [res.inputs.time, res.inputs.signals.values], 'VariableNames',{'time','in1','in2'} );
T = join(T, array2table( ...
    [res.cal_time.time res.cal_time.signals.values], ...
    'VariableNames',{'time','cal_time'}) );
writetable(T, 'simex1_nmpc_inputs_etc_st1e-6.csv')
