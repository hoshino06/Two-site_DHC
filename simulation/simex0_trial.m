% twosite.m 
clear

%% simulink モデルの呼び出し
addpath('../simulator')
open_system('twosite_system')

%% シミュレーション設定
% サンプリング時間および予測ホライズン
set_param('twosite_system/mpc', 'Tstep', '2.0')
set_param('twosite_system/mpc', 'Nhorizon', '5')

% 電力の指令値に関する設定
set_param('twosite_system/power_ref','Pnominal', '1.0')
%set_param('twosite_system/power_ref','ASamplitude','0.4')

% 熱の指令値に関する設定
NominalHref = '1.68667';
Offset0 = '0.0';
Offset1 = '-0.0';
Offset2 = '0.0+0.0';
OffsetChgTime1 = '60*15';
OffsetChgTime2 = '60*30';
set_param('twosite_system/HeatRef', 'Value', NominalHref)
set_param('twosite_system/HeatOffset1','Before', Offset0)
set_param('twosite_system/HeatOffset1','After',  Offset1)
set_param('twosite_system/HeatOffset2','Before', '0')
set_param('twosite_system/HeatOffset2','After',  Offset2)
set_param('twosite_system/HeatOffset1','Time', OffsetChgTime1)
set_param('twosite_system/HeatOffset2','Time', OffsetChgTime2)

% MPCの評価関数の重み
Qz = 'blkdiag( 0.1, eye(4), 0.01, 1*eye(3) )'; % パラメータは文字列で指定
Rv = 'eye(2)';
set_param('twosite_system/mpc', 'Qz', Qz)
set_param('twosite_system/mpc', 'Rv', Rv)
clear Qz Rv

% 圧力に関する制約条件
set_param('twosite_system/mpc', 'Plim', '[-50, 50]') %kPa

% 入力に関する制約条件
set_param('twosite_system/mpc', 'u1max', '0.6')
set_param('twosite_system/mpc', 'u2max', '1.0')

% 計算の時間
set_param('twosite_system','StartTime','-20', 'StopTime','60*40')

%% シミュレーションの実行
% 
set_param('twosite_system/power_ref','ASamplitude','0.4')
res = sim('twosite_system');
T = array2table(res.tout, 'VariableNames',{'time'} );
T = join(T, array2table(res.power,    'VariableNames',{'time','regd','power'}) );
T = join(T, array2table(res.heatflow, 'VariableNames',{'time','heatflow'}) );
T = join(T, array2table(res.pressure, 'VariableNames',{'time','pressure'}) );
T = join(T, array2table(res.inputs,   'VariableNames',{'time','in1','in2'}) );
