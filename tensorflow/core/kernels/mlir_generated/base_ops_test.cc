/* Copyright 2020 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#include "tensorflow/core/kernels/mlir_generated/base_ops_test.h"

#include <cstdint>

namespace tensorflow {
namespace test {

TensorShape DefaultInputShape() { return TensorShape{7, 13}; }

TensorShape DefaultInputShapeExceedingInt32() {
  const int64_t kExceetingInt32 = (static_cast<int64_t>(1) << 32) + 123;
  return TensorShape{kExceetingInt32};
}

}  // namespace test
}  // namespace tensorflow
