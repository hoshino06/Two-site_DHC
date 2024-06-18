function dydt = variational_equation(t, y, v)

x  = y(1:13);
dxdt = vf_closed_loop(x,v);

phi = reshape(y(13+1:13+15*15), [15,15]);
A = blkdiag( [zeros(4,1) eye(4); zeros(1,5)], [zeros(3,1) eye(3); zeros(1,4)]);
B = [ [zeros(4,1); 1; zeros(4,1)] [zeros(5,1); zeros(3,1); 1]]; 
dphidt_mtr = [A zeros(9,4) B; ve_drdx(x) / ve_dphidx(x) zeros(4,2); zeros(2,15)] * phi;
dphidt = reshape(dphidt_mtr, [15*15,1]);

dydt = [dxdt; dphidt];

end