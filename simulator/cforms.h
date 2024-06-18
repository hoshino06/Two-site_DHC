// utility
void List(double v0, double v1, double v2, double v3, double v4, double v5, double v6, double v7, double v8, 
        double v9, double v10, double v11, double v12, double*v );

// model equations
void derivs_of_Electricity(double *x, double *u, double *dxdt);
void derivs_of_Heat(double *x, double *u, double *dxdt);
void derivs_of_GasTurbine(double *x, double *u, double *dxdt);
void output_of_GasTurbine(double *x, double *pm, double *q);
void two_site_system(double *x, double *u, double *dxdt);

// for staedy flow calculation
void equil_xe(double *u, double *del, double *dxedt);
void equil_xh(double *u, double *xh, double *dxhdt);
void steady_flow_value(double *xe, double *xh, double *flow);

// derived functions
void state_transformation(double *x, double *xi, double*eta);
void decoupling_matrix(double *x, double A[2][2]);
void decoupling_shift_term(double *x, double b[2]);
void linearizing_control_law(double *x, double *v, double *u);
void stabilizing_control_law(double *x, double *v, double *u);
void drdx(double *x, double deriv[4][13]);
void dphidx(double *x, double deriv[13][13]);
void deriv_det_dphi_dx(double *x, double *deriv);

