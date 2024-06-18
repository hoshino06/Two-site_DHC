% 定常状態でのエネルギーフローを計算し
% 入力に関する制約をxiの制約へと変換

% % [u1, u2] = [0.5, 0.5] で計算するコード
% steady_eq = @(x) steady_flow_equation(x(1:2),x(3:4),[0.5,0.5]);
% xsteady = fsolve(steady_eq, [0,0,0,0], ...
%                    optimoptions('fsolve','Display','none'));
% flow = steady_flow(xsteady(1:2),xsteady(3:4));

function [a, b] = steady_flow_constraint(u1, u2)

    if isnan(u1)
        U1 = [0.3,  0.7];
        U2 = [u2, u2];
    elseif isnan(u2)
        U1 = [u1, u1];
        U2 = [0.3,  0.7];
    else
        error('U1 と U2 のいずれかは nan を指定してください');
    end
        
    % １点目でのフロー（point a）
    steady_eq = @(x) steady_flow_equation(x(1:2),x(3:4),[U1(1),U2(1)]);
    xsteady = fsolve(steady_eq, [0,0,0,0], ...
                       optimoptions('fsolve','Display','none'));
    fpa = steady_flow(xsteady(1:2),xsteady(3:4));

    % ２点目でのフロー（point b）
    steady_eq = @(x) steady_flow_equation(x(1:2),x(3:4),[U1(2),U2(2)]);
    xsteady = fsolve(steady_eq, [0,0,0,0], ...
                       optimoptions('fsolve','Display','none'));
    fpb = steady_flow(xsteady(1:2),xsteady(3:4));
    
    % 傾きと切片
    a = (fpa(2)-fpb(2)) / (fpa(1)-fpb(1));
    b = (fpa(1)*fpb(2)-fpb(1)*fpa(2)) / (fpa(1)-fpb(1));
end