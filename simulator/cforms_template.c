// cforms.c 
// 
#include "mdefs.h"
#include "math.h"
#include "stdio.h"

void List(double v0, double v1, double v2, double v3, double v4, double v5, double v6, double v7, double v8, 
        double v9, double v10, double v11, double v12, double*v ){
    v[0] = v0;
    v[1] = v1;
    v[2] = v2;
    v[3] = v3;
    v[4] = v4;
    v[5] = v5;
    v[6] = v6;
    v[7] = v7;
    v[8] = v8;
    v[9] = v9;
    v[10]= v10;
    v[11]= v11;
    v[12]= v12;
}

void derivs_of_Electricity(double *x, double *u, double *dxdt)
{
  double del1 = x[0];
  double omg1 = x[1];
  double del2 = x[2];
  double omg2 = x[3];
  double pm1 = u[0];
  double pm2 = u[1];

  dxdt[0] = <* DerivOfElectricity[[1]] *>;
  dxdt[1] = <* DerivOfElectricity[[2]] *>;
  dxdt[2] = <* DerivOfElectricity[[3]] *>;
  dxdt[3] = <* DerivOfElectricity[[4]] *>;
}

void derivs_of_Heat(double *x, double *u, double *dxdt)
{
  double p1 = x[0];
  double p2 = x[1];
  double w = x[2];
  double Q1 = u[0];
  double Q2 = u[1];
  
  dxdt[0] = <* DerivOfHeat[[1]] *>;
  dxdt[1] = <* DerivOfHeat[[2]] *>;
  dxdt[2] = <* DerivOfHeat[[3]] *>;
}

void derivs_of_GasTurbine(double *x, double *u, double *dxdt)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double u1 = u[0];
  double u2 = u[1];
  
  dxdt[0] = <* DerivOfGasTurbine[[1]] *>;
  dxdt[1] = <* DerivOfGasTurbine[[2]] *>;
  dxdt[2] = <* DerivOfGasTurbine[[3]] *>;
  dxdt[3] = <* DerivOfGasTurbine[[4]] *>;
  dxdt[4] = <* DerivOfGasTurbine[[5]] *>;
  dxdt[5] = <* DerivOfGasTurbine[[6]] *>;

}

void output_of_GasTurbine(double *x, double *pm, double *q)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];

  pm[0] = <* OutputOfGasTurbine[[1]] *>;
  pm[1] = <* OutputOfGasTurbine[[2]] *>; 
  q[0] =  <* OutputOfGasTurbine[[3]] *>;
  q[1] =  <* OutputOfGasTurbine[[4]] *>; 
}

void two_site_system(double *x, double *u, double *dxdt)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10 = x[9];
  double x11 = x[10];
  double x12 = x[11];
  double x13 = x[12];
  double u1  = u[0];
  double u2  = u[1];
  
  dxdt[0]  = <* TwoSiteSystem[[1]] *>;
  dxdt[1]  = <* TwoSiteSystem[[2]] *>;
  dxdt[2]  = <* TwoSiteSystem[[3]] *>;
  dxdt[3]  = <* TwoSiteSystem[[4]] *>;
  dxdt[4]  = <* TwoSiteSystem[[5]] *>;
  dxdt[5]  = <* TwoSiteSystem[[6]] *>;
  dxdt[6]  = <* TwoSiteSystem[[7]] *>;
  dxdt[7]  = <* TwoSiteSystem[[8]] *>;
  dxdt[8]  = <* TwoSiteSystem[[9]] *>;
  dxdt[9]  = <* TwoSiteSystem[[10]] *>;
  dxdt[10] = <* TwoSiteSystem[[11]] *>;
  dxdt[11] = <* TwoSiteSystem[[12]] *>;
  dxdt[12] = <* TwoSiteSystem[[13]] *>;
}

// for staedy flow calculation

void equil_xe(double *u, double *xe, double *dxedt)
{
  double u1 = u[0];
  double u2 = u[1];
  double del1 = xe[0];
  double del2 = xe[1];
  dxedt[0] = <* equilXe[[1]] *>;
  dxedt[1] = <* equilXe[[2]] *>;
}

void equil_xh(double *u, double *xh, double *dxhdt)
{
  double u1 = u[0];
  double u2 = u[1];
  double w    = xh[0];
  double delP = xh[1]; 
  dxhdt[0] = <* equilXh[[1]] *>;
  dxhdt[1] = <* equilXh[[2]] *>;
}

void steady_flow_value(double *xe, double *xh, double *flow)
{
  double del1 = xe[0];
  double del2 = xe[1];
  double w    = xh[0];
  double delP = xh[1]; 
  flow[0] = <* flowElec *>;
  flow[1] = <* flowHeat *>;
}


// derived functions

void state_transformation(double *x, double *xi, double*eta)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10 = x[9];
  double x11 = x[10];
  double x12 = x[11];
  double x13 = x[12];

  xi[0]  = <* StateTransformation[[1]] *>;
  xi[1]  = <* StateTransformation[[2]] *>;
  xi[2]  = <* StateTransformation[[3]] *>;
  xi[3]  = <* StateTransformation[[4]] *>;
  xi[4]  = <* StateTransformation[[5]] *>;
  xi[5]  = <* StateTransformation[[6]] *>;
  xi[6]  = <* StateTransformation[[7]] *>;
  xi[7]  = <* StateTransformation[[8]] *>;
  xi[8]  = <* StateTransformation[[9]] *>;
  eta[0] = <* StateTransformation[[10]] *>;
  eta[1] = <* StateTransformation[[11]] *>;
  eta[2] = <* StateTransformation[[12]] *>;
  eta[3] = <* StateTransformation[[13]] *>;
}



void linearizing_control_law(double *x, double *v, double *u)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10= x[9];
  double x11= x[10];
  double x12= x[11];
  double x13= x[12];
  double v1 = v[0];
  double v2 = v[1];

  u[0] =  <* PartialLinearization[[1]] *>;
  u[1] =  <* PartialLinearization[[2]] *>;
}

void decoupling_matrix(double *x, double A[2][2])
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10= x[9];
  double x11= x[10];
  double x12= x[11];
  double x13= x[12];

  A[0][0] =  <* DecouplingMatrix[[1, 1]] *>;
  A[0][1] =  <* DecouplingMatrix[[1, 2]] *>;
  A[1][0] =  <* DecouplingMatrix[[2, 1]] *>;
  A[1][1] =  <* DecouplingMatrix[[2, 2]] *>;
}

void decoupling_shift_term(double *x, double b[2])
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10= x[9];
  double x11= x[10];
  double x12= x[11];
  double x13= x[12];

  b[0] = <* DecouplingShiftTerm[[1]] *>;
  b[1] = <* DecouplingShiftTerm[[2]] *>;
}

void stabilizing_control_law(double *x, double *v, double *u)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10= x[9];
  double x11= x[10];
  double x12= x[11];
  double x13= x[12];
  double v1 = v[0];
  double v2 = v[1];

  u[0] = <* StabilizingControlLaw[[1]]  *>;
  u[1] = <* StabilizingControlLaw[[2]]  *>;
}

void drdx(double *x, double deriv[13][13])
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10= x[9];
  double x11= x[10];
  double x12= x[11];
  double x13= x[12];

  double *deriv0 = &deriv[0][0];
  double *deriv1 = &deriv[1][0];
  double *deriv2 = &deriv[2][0];
  double *deriv3 = &deriv[3][0];

  <* Join[drdx[[1]], {deriv0} ]  *>;  // List( drdx[[1]], deriv[0] )
  <* Join[drdx[[2]], {deriv1} ]  *>;  // List( drdx[[2]], deriv[1] )
  <* Join[drdx[[3]], {deriv2} ]  *>;  // List( drdx[[3]], deriv[2] )
  <* Join[drdx[[4]], {deriv3} ]  *>;  // List( drdx[[4]], deriv[3] )
}

void dphidx(double *x, double deriv[13][13])
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10= x[9];
  double x11= x[10];
  double x12= x[11];
  double x13= x[12];

  double *deriv0 = &deriv[0][0];
  double *deriv1 = &deriv[1][0];
  double *deriv2 = &deriv[2][0];
  double *deriv3 = &deriv[3][0];
  double *deriv4 = &deriv[4][0];
  double *deriv5 = &deriv[5][0];
  double *deriv6 = &deriv[6][0];
  double *deriv7 = &deriv[7][0];
  double *deriv8 = &deriv[8][0];
  double *deriv9 = &deriv[9][0];
  double *deriv10= &deriv[10][0];
  double *deriv11= &deriv[11][0];
  double *deriv12= &deriv[12][0];
  
  <* Join[dphidx[[1]], {deriv0} ]  *>;  // List( drdx[[1]], deriv[0] )
  <* Join[dphidx[[2]], {deriv1} ]  *>;  // List( drdx[[2]], deriv[1] )
  <* Join[dphidx[[3]], {deriv2} ]  *>;  // List( drdx[[3]], deriv[2] )
  <* Join[dphidx[[4]], {deriv3} ]  *>;  // List( drdx[[4]], deriv[3] )
  <* Join[dphidx[[5]], {deriv4} ]  *>;  // List( drdx[[1]], deriv[0] )
  <* Join[dphidx[[6]], {deriv5} ]  *>;  // List( drdx[[2]], deriv[1] )
  <* Join[dphidx[[7]], {deriv6} ]  *>;  // List( drdx[[3]], deriv[2] )
  <* Join[dphidx[[8]], {deriv7} ]  *>;  // List( drdx[[4]], deriv[3] )
  <* Join[dphidx[[9]], {deriv8} ]  *>;  // List( drdx[[1]], deriv[0] )
  <* Join[dphidx[[10]],{deriv9} ]  *>;  // List( drdx[[2]], deriv[1] )
  <* Join[dphidx[[11]],{deriv10}]  *>;  // List( drdx[[3]], deriv[2] )
  <* Join[dphidx[[12]],{deriv11}]  *>;  // List( drdx[[4]], deriv[3] )
  <* Join[dphidx[[13]],{deriv12}]  *>;  // List( drdx[[4]], deriv[3] )

}

void deriv_det_dphi_dx(double *x, double *deriv)
{
  double x1 = x[0];
  double x2 = x[1];
  double x3 = x[2];
  double x4 = x[3];
  double x5 = x[4];
  double x6 = x[5];
  double x7 = x[6];
  double x8 = x[7];
  double x9 = x[8];
  double x10 = x[9];
  double x11 = x[10];
  double x12 = x[11];
  double x13 = x[12];

  deriv[0]  = <* DerivDetdphidx[[1]] *>;
  deriv[1]  = <* DerivDetdphidx[[2]] *>;
  deriv[2]  = <* DerivDetdphidx[[3]] *>;
  deriv[3]  = <* DerivDetdphidx[[4]] *>;
  deriv[4]  = <* DerivDetdphidx[[5]] *>;
  deriv[5]  = <* DerivDetdphidx[[6]] *>;
  deriv[6]  = <* DerivDetdphidx[[7]] *>;
  deriv[7]  = <* DerivDetdphidx[[8]] *>;
  deriv[8]  = <* DerivDetdphidx[[9]] *>;
  deriv[9]  = <* DerivDetdphidx[[10]] *>;
  deriv[10] = <* DerivDetdphidx[[11]] *>;
  deriv[11] = <* DerivDetdphidx[[12]] *>;
  deriv[12] = <* DerivDetdphidx[[13]] *>;
}

