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

#ifndef TF_KERNEL_GEN_PASSES
#define TF_KERNEL_GEN_PASSES

include "mlir/Pass/PassBase.td"

def TFKernelToLLVMPass : Pass<"tf-kernel-to-llvm", "ModuleOp"> {
  let summary = "Pass for applying LLVM legalization patterns.";
  let constructor = "transforms::CreateTFKernelToLLVMPass()";
  let options = [
      Option<"blob_annotation_", "blob-annotation", "std::string",
           /*default=*/"\"gpu.binary_blob\"", "Blob attribute name">,
  ];
}

def EmbedTFFrameworkPass
    : Pass<"embed-tf-framework", "ModuleOp"> {
  let summary = "Pass to embed TF Framework for allocation and assertions,";
  let constructor = "tf_framework::CreateEmbedTFFrameworkPass()";
}

def RewriteTFFrameworkAssert : Pass<"rewrite-tf-framework-assert", "ModuleOp"> {
  let summary = "Pass to rewrite TFAssertOps to CondBranchOp";
  let constructor = "tf_framework::CreateRewriteTFFrameworkAssert()";
}

def BufferReusePass : FunctionPass<"buffer-reuse"> {
  let summary = "Pass to find and annotate candidates for buffer reuse.";
  let constructor = "transforms::CreateBufferReusePass()";
}

def ShapeToDescriptorsPass : Pass<"shape-to-descriptors", "ModuleOp"> {
  let summary = "Pass to transform shape computations to descriptors";
  let constructor = "transforms::CreateShapeToDescriptorsPass()";
}

def ComputeOpAndFuncBufferizePass : Pass<"computeop-and-func-bufferize", "ModuleOp"> {
  let summary = "Pass to transform compute operations (hlo and linalg) on "
                "values to buffer based ones.";
  let constructor = "transforms::CreateComputeOpAndFuncBufferizePass()";
}

def FinalBufferizePass : Pass<"final-bufferize", "ModuleOp"> {
  let summary = "Pass to transform late operations on values to buffer based "
                "ones.";
  let constructor = "transforms::CreateFinalBufferizePass()";
}

def GpuKernelToNVVMPass : Pass<"gpu-kernel-to-nvvm", "gpu::GPUModuleOp"> {
  let summary = "Pass to transform a gpu module to nvvm.";
  let constructor = "transforms::CreateGpuKernelToNvvmPass()";
}

def GpuKernelToROCDLPass : Pass<"gpu-kernel-to-rocdl", "gpu::GPUModuleOp"> {
  let summary = "Pass to transform a gpu module to rocdl.";
  let constructor = "transforms::CreateGpuKernelToRocdlPass()";
}

def GpuKernelToBlobPass : Pass<"gpu-kernel-to-blob", "gpu::GPUModuleOp"> {
  let summary = "Pass to annotate GPU Module with its PTX";
  let options = [
    Option<"blob_annotation_", "blob-annotation", "std::string",
           /*default=*/"\"gpu.binary_blob\"", "Blob attribute name">,
    ListOption<"architectures_", "arch", "std::string", "GPU architectures">,
    Option<"generate_fatbin_", "generate-fatbin", "bool", /*default=*/"true",
           "Bundle machine code for the different architectures in one "
           "fatbin.">,
    Option<"print_ptx_", "print-ptx", "bool", /*default=*/"false",
           "Print generated PTX code per target architecture.">,
  ];
  let constructor = "transforms::CreateGpuKernelToBlobPass()";
}

def ParallelLoopsToSequential : FunctionPass<"parallel-loops-to-sequential"> {
  let summary = "Pass to convert scf::ParallelOp to scf::ForOp";
  let constructor = "transforms::CreateParallelLoopsToSequential()";
}

def PropagateTfAbiKnowledgeToKernels
    : FunctionPass<"propagate-tf-abi-knowledge-to-kernels"> {
  let summary = "Pass to propagate tensorflow ABI knowledge to kernels";
  let constructor = "transforms::CreatePropagateTfAbiKnowledgeToKernels()";
}

def PropagateShapeKnowledgeToKernels
    : FunctionPass<"propagate-shape-knowledge-to-kernels"> {
  let summary = "Pass to propagate shape information into kernels";
  let constructor = "transforms::CreatePropagateShapeKnowledgeToKernels()";
}

def EmbedMemRefPrintsPass : FunctionPass<"embed-memref-prints"> {
  let summary = "Pass to print content of memrefs";
  let constructor = "transforms::CreateEmbedMemRefPrintsPass()";
}

def MapParallelLoopsPass
    : FunctionPass<"map-parallel-loops-to-gpu"> {
  let summary = "Greedily maps loops to GPU hardware dimensions.";
  let constructor = "transforms::CreateMapParallelLoopsPass()";
  let description = [{
    Greedily maps loops to GPU hardware dimensions.
  }];
}

def FuseInnerParallelLoopsPass
    : FunctionPass<"fuse-inner-parallel-loops"> {
  let summary = "Limited pass to forward stores to loads.";
  let constructor = "transforms::CreateFuseInnerParallelLoopsPass()";
  let description = [{
    Directs parallel loop fusion to the inner loops. This cannot be done with
    a passmanager alone ATM, as nested pass managers require operations to
    be closed from above.
  }];
}

def ShapeSimplification
    : FunctionPass<"kernelgen-shape-simplification"> {
  let summary = "Simplify shape ops";
  let constructor = "transforms::CreateShapeSimplification()";
}

def VectorizationPass : FunctionPass<"vectorization"> {
  let summary = "Pass to create vectorized operations for CPU.";
  let constructor = "transforms::CreateVectorizationPass()";
  let description = [{
    Takes linalg loops on buffers and vectorizes the loads/stores and operations
    in between. This is intended for the CPU backend.
  }];
}

def VectorizationCleanupPass : FunctionPass<"vectorization-cleanup"> {
  let summary = "Pass to remove dead code in VectorizationPass.";
  let constructor = "transforms::CreateVectorizationCleanupPass()";
  let description = [{
    VectorizationPass creates some memory transfers that are unneeded but cannot
    be safely removed by current generic infrastructure. This removes the
    specific operations.
  }];
}

#endif // TF_KERNEL_GEN_PASSES
