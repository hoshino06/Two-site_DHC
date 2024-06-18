/* vf_closed_loop.cpp
* C++ MEX Function to calculate the values of steady flow from [del1, del2](phase angle), and w(steam velocity)  
* compile command: mex steady_flow.cpp cforms.cpp
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
                
        // dxdt
        double flow[2];
	    steady_flow_value(xe, xh, flow);
        
    // calcurate outputs
    ArrayFactory factory;
    Array out = factory.createArray<double>({ 2,1 }, {});
	out[0] = flow[0];
	out[1] = flow[1];
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
