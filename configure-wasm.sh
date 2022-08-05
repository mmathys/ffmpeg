WASM_SYSROOT=/usr/local/wasi-sdk/share/wasi-sysroot
WASM_TOOLCHAIN_BIN=/usr/local/wasi-sdk/bin

WASM_CC=$WASM_TOOLCHAIN_BIN/clang
WASM_CXX=$WASM_TOOLCHAIN_BIN/clang++
WASM_CPP=$WASM_TOOLCHAIN_BIN/clang-cpp
WASM_AR=$WASM_TOOLCHAIN_BIN/llvm-ar
WASM_NM=$WASM_TOOLCHAIN_BIN/llvm-nm
WASM_RANLIB=$WASM_TOOLCHAIN_BIN/llvm-ranlib
WASM_LD=$WASM_TOOLCHAIN_BIN/wasm-ld
WASM_LDSHARED=$WASM_TOOLCHAIN_BIN/wasm-ld
#WASM_LDFLAGS="-Xlinker --stack-first -Xlinker --no-check-features"
WASM_LDFLAGS="-Xlinker --stack-first -Xlinker --no-check-features -lwasi-emulated-process-clocks"
#WASM_CFLAGS="-O3 --sysroot=$WASM_SYSROOT -mno-atomics -D__faasm"
WASM_CFLAGS="-O3 --sysroot=$WASM_SYSROOT -mno-atomics -D__faasm -D_WASI_EMULATED_PROCESS_CLOCKS"
# source ${CPP_ROOT}/Makefile.envs

LDFLAGS=$WASM_LDFLAGS
CFLAGS="$WASM_CFLAGS -lfaasm -Xlinker --max-memory=4294901760 \
        -Wl,-z,stack-size=4194304 -Wl, -Xlinker --export=main -Xlinker \
        --stack-first -Xlinker --export=_faasm_zygote -Xlinker \
        --export=__heap_base -Xlinker --export=__data_end -Xlinker \
        --export=__wasm_call_ctors"


#     --disable-programs \

cd ~/ffmpeg_sources && \
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
     --target-os=none \
     --arch=x86_32 \
     --prefix="$HOME/ffmpeg_build" \
     --bindir="$HOME/bin" \
     --enable-cross-compile \
     --disable-x86asm \
     --disable-inline-asm \
     --disable-network \
     --disable-stripping \
     --disable-doc \
     --extra-cflags="$CFLAGS" \
     --extra-cxxflags="$CFLAGS" \
     --extra-ldflags="$LDFLAGS" \
     --extra-libs="-lpthread -lm" \
     --ar=${WASM_AR} \
     --nm=${WASM_NM} \
     --ranlib=${WASM_RANLIB} \
     --cc=${WASM_CC} \
     --cxx=${WASM_CXX} \
     --objcc=${WASM_CC} \
     --dep-cc=${WASM_CC} && \
PATH="$HOME/bin:$PATH" make -j && \
make install 
hash -r
