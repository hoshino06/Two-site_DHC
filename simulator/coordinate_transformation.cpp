/* coordinate_transformation.cpp
* C++ MEX Function to calculate drdx for given x 
* compile command: mex ve_drdx.cpp cforms.cpp
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
        
        // calculation of coordinate transformation
        double xi[9];
        double eta[4];        
        state_transformation(x, xi, eta);
        
        // calcurate outputs
        ArrayFactory factory;
        Array out1 = factory.createArray<double>({ 9,1 }, {});
        for(i=0; i<9; i++){
                out1[i] = xi[i];
            }
        Array out2 = factory.createArray<double>({ 4,1 }, {});
        for(i=0; i<4; i++){
                out2[i] = eta[i];
            }
        
        outputs[0] = out1; 
        outputs[1] = out2;   

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
        // Check number of outputs
        if (outputs.size() > 2) {
         matlabPtr->feval(u"error",
                0,
                std::vector<Array>({ factory.createScalar("Only one output is returned") }));
        }  
    }
};        
