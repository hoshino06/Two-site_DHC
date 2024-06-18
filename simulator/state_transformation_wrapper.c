
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
#define u_width 13
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
void state_transformation_Outputs_wrapper(const real_T *x,
			real_T *xi,
			real_T *eta)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* ���̃T���v���́A�o�͂���͂Ɠ������ݒ肵�܂�
 y0[0] = u0[0]; 
 ���f�M���̏ꍇ�́A�����g�p���܂�: y0[0].re = u0[0].re; 
 y0[0].im = u0[0].im;
 y1[0].re = u1[0].re;
 y1[0].im = u1[0].im;
 */
state_transformation(x, xi, eta);
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


