% twosite.m 
clear

%% simulink モデルの呼び出し
addpath('../simulator')
model = 'twosite_system_open_loop';
load_system(model)

%% シミュレーション設定
% 電力の指令値に関する設定
set_param([model, '/power_ref'],'Pnominal', '1.0')
set_param([model, '/power_ref'],'ASamplitude','0.4')

% 計算の時間
set_param(model, 'StartTime','-180', 'StopTime','60*40')

%% シミュレーションの実行
res = sim(model);
T = array2table(res.tout, 'VariableNames',{'time'} );
T = join(T, array2table(res.power,    'VariableNames',{'time','regd','power','in1','in2'}) );
T = join(T, array2table(res.heatflow, 'VariableNames',{'time','heatflow'}) );
T = join(T, array2table(res.pressure, 'VariableNames',{'time','pressure'}) );
%T = join(T, array2table(res.inputs,   'VariableNames',{'time','in1','in2'}) );
writetable(T, 'open_loop.csv')
