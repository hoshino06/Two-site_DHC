
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
#include "cforms.h"
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 2
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output function
 *
 */
void electric_subsystem_Outputs_wrapper(real_T *xe,
			const real_T *xC)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* このサンプルは、出力を入力と等しく設定します
 y0[0] = u0[0]; 
 複素信号の場合は、次を使用します: y0[0].re = u0[0].re; 
 y0[0].im = u0[0].im;
 y1[0].re = u1[0].re;
 y1[0].im = u1[0].im;
 */
xe[0] = xC[0];
xe[1] = xC[1];
xe[2] = xC[2];
xe[3] = xC[3];
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
 * Derivatives function
 *
 */
void electric_subsystem_Derivatives_wrapper(const real_T *Pm,
			real_T *xe,
			real_T *dx,
			real_T *xC)
{
/* %%%-SFUNWIZ_wrapper_Derivatives_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * コード例
 * dx[0] = xC[0];
 */
derivs_of_Electricity(xC,Pm,dx);
/* %%%-SFUNWIZ_wrapper_Derivatives_Changes_END --- EDIT HERE TO _BEGIN */
}

