/** Tensorflow for D.

    TODO:
    - https://github.com/tensorflow/tensorflow/blob/master/tensorflow/cc/tutorials/example_trainer.cc
*/
module tfd;

import mir.ndslice;
import std.stdio;
// import core.stdcpp.memory : unique_ptr;

extern (C++, tensorflow)
struct Scope
{
    static Scope NewRootScope();

//     struct Impl;

// private:
//     unique_ptr!Impl impl_;
}

unittest
{
    
}

unittest
{
    // writeln("graph def usage");
    // TODO(jeff,opensource): This should really be a more interesting
    // computation.  Maybe turn this into an mnist model instead?
    // Scope root = Scope.NewRootScope();
    // import tfd.ops;

    // // A = [3 2; -1 0].  Using Const<float> means the result will be a
    // // float tensor even though the initializer has integers.
    // auto a = Const!float(root, [[3, 2], [-1, 0]]);

    // // x = [1.0; 1.0]
    // auto x = Const(root.WithOpName("x"), [[1.0f], [1.0f]]);

    // // y = A * x
    // auto y = MatMul(root.WithOpName("y"), a, x);

    // // y2 = y.^2
    // auto y2 = Square(root, y);

    // // y2_sum = sum(y2).  Note that you can pass constants directly as
    // // inputs.  Sum() will automatically create a Const node to hold the
    // // 0 value.
    // auto y2_sum = Sum(root, y2, 0);

    // // y_norm = sqrt(y2_sum)
    // auto y_norm = Sqrt(root, y2_sum);

    // // y_normalized = y ./ y_norm
    // Div(root.WithOpName("y_normalized"), y, y_norm);

    // GraphDef def;
    // TF_CHECK_OK(root.ToGraphDef(&def));
}

// unittest
// {
//     writeln("example trainer");

//     struct Options {
//         int num_concurrent_sessions = 1;   // The number of concurrent sessions
//         int num_concurrent_steps = 10;     // The number of concurrent steps
//         int num_iterations = 100;          // Each step repeats this many times
//         bool use_gpu = false;              // Whether to use gpu in the training
//     };

// }
