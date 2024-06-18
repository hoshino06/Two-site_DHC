/* vf_closed_loop.cpp
* C++ MEX Function to calculate the vectorfield of the closed-loop system under linearizing control law 
* compile command: mex vf_closed_loop.cpp cforms.cpp
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
        TypedArray<double> xArray = std::move(inputs[0]);
        double x[13];
        int i = 0;
        for (auto x_i : xArray) {
            x[i++] = x_i;
        }
        TypedArray<double> vArray = std::move(inputs[1]);
        double v[2];
        i = 0;
        for (auto v_i : vArray) {
            v[i++] = v_i;
        }
        
        // control input
        double u[2];
        stabilizing_control_law(x, v, u);
        
        // dxdt
        double dxdt[13];
        two_site_system(x, u, dxdt);
        
        // calcurate outputs
        ArrayFactory factory;
        Array out = factory.createArray<double>({ 13,1 }, {});
        for(i=0; i<13; i++){
            out[i] = dxdt[i];
        }
          
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
