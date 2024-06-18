/* vf_closed_loop.cpp
* C++ MEX Function to calculate stady equation to solve for [del1, del2](phase angle), and w(steam velocity)  
* compile command: mex steady_flow_equaion.cpp cforms.cpp
*/
#include "mex.hpp"
#include "mexAdapter.hpp"
#include "cforms.h"

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function {
public:
    void operator()(ArgumentList outputs, ArgumentList inputs) {
        checkArguments(outputs, inputs); 
        
        // copy inputs to c arrays
        TypedArray<double> xeArray = std::move(inputs[0]);
        double xe[2];
        int i = 0;
        for (auto x_i : xeArray) {
            xe[i++] = x_i;
        }
        TypedArray<double> xhArray = std::move(inputs[1]);
        double xh[2];
        i = 0;
        for (auto x_i : xhArray) {
            xh[i++] = x_i;
        }
        TypedArray<double> uArray = std::move(inputs[2]);
        double u[2];
        i = 0;
        for (auto u_i : uArray) {
            u[i++] = u_i;
        }
                
        // dxdt
        double dxedt[2];
        double dxhdt[2];
	equil_xe(u, xe, dxedt);
	equil_xh(u, xh, dxhdt);
        
    // calcurate outputs
    ArrayFactory factory;
    Array out = factory.createArray<double>({ 4,1 }, {});
	out[0] = dxedt[0];
	out[1] = dxedt[1];
	out[2] = dxhdt[0];
	out[3] = dxhdt[1];          
    outputs[0] = out;   
    }
   
    void checkArguments(ArgumentList outputs, ArgumentList inputs) {
        // Get pointer to engine
        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
        // Get array factory
        ArrayFactory factory;
        // Check first input argument
        if (inputs[0].getType() != ArrayType::DOUBLE ||
            inputs[0].getType() == ArrayType::COMPLEX_DOUBLE )
        {
            matlabPtr->feval(u"error",
                0,
                std::vector<Array>({ factory.createScalar("First input must be scalar double") }));
        }
        // Check second input argument
        if (inputs[1].getType() != ArrayType::DOUBLE ||
            inputs[1].getType() == ArrayType::COMPLEX_DOUBLE)
        {
            matlabPtr->feval(u"error",
                0,
            std::vector<Array>({ factory.createScalar("Input must be double array") }));
        }
        // Check number of outputs
        if (outputs.size() > 1) {
         matlabPtr->feval(u"error",
                0,
                std::vector<Array>({ factory.createScalar("Only one output is returned") }));
        }  
    }
};        
