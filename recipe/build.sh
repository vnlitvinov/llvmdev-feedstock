mkdir build
cd build

if [[ "$CC_FOR_BUILD" != "" && "$CC_FOR_BUILD" != "$CC" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DCROSS_TOOLCHAIN_FLAGS_NATIVE=-DCMAKE_C_COMPILER=$CC_FOR_BUILD;-DCMAKE_CXX_COMPILER=$CXX_FOR_BUILD;-DCMAKE_EXE_LINKER_FLAGS=;-DCMAKE_MODULE_LINKER_FLAGS=;-DCMAKE_SHARED_LINKER_FLAGS=;-DCMAKE_C_FLAGS=-O2;-DCMAKE_CXX_FLAGS=-O2"
  CMAKE_ARGS="${CMAKE_ARGS} -DLLVM_HOST_TRIPLE=$(echo $HOST | sed s/conda/unknown/g) -DLLVM_DEFAULT_TARGET_TRIPLE=$(echo $HOST | sed s/conda/unknown/g)"
fi

cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_INCLUDE_TESTS=OFF \
      -DLLVM_INCLUDE_UTILS=OFF \
      -DLLVM_INCLUDE_DOCS=OFF \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_ENABLE_TERMINFO=OFF \
      ${CMAKE_ARGS} ..

if [ $target_platform = osx-arm64 ]; then
  make CONFIGURE_LLVM_NATIVE
  cd NATIVE/
  make -j${CPU_COUNT}
fi

make -j${CPU_COUNT}
make install
