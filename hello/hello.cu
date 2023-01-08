#include <iostream>

#include "hello.hpp"

#undef __noinline__
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>

#include <memory>
#define __noinline__ __attribute__((noinline))

namespace hello {
class op_functor {
  const float a;

 public:
  explicit op_functor(float a) : a(a) {}
  __host__ __device__ auto operator()(const float& x, const float& y) const
      -> float {
    return a * x + y;
  }
};

void hello() {
  const size_t NELEMS = 10;
  const float X = 1.;
  const float Y = 2.;
  const float A = 5.;
  thrust::device_vector<float> d_x(NELEMS, X);
  thrust::device_vector<float> d_y(NELEMS, Y);
  thrust::transform(d_x.begin(), d_x.end(), d_y.begin(), d_y.begin(),
                    op_functor(A));
  thrust::host_vector<float> res = d_y;
  std::cout << A << " * " << X << " + " << Y << " * "
            << "[" << NELEMS << "]:\n";
  std::cout << "[";
  for (auto elem = d_y.begin(); elem != d_y.end(); elem++) {
    std::cout << (*elem);
    auto tp = elem;
    if (tp != --d_y.end()) {
      std::cout << ", ";
    }
  }
  std::cout << "]\n";
}
}  // namespace hello
