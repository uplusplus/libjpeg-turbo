# Set these variables to suit your needs
NDK_PATH=/opt/android-ndk-r10
BUILD_PLATFORM="linux-x86_64"
TOOLCHAIN_VERSION="4.6"
ANDROID_VERSION="16"

# It should not be necessary to modify the rest
HOST=arm-linux-androideabi
SYSROOT=${NDK_PATH}/platforms/android-${ANDROID_VERSION}/arch-arm
export CFLAGS="-march=armv7-a -mfloat-abi=softfp -fprefetch-loop-arrays \
  -D__ANDROID_API__=${ANDROID_VERSION} --sysroot=${SYSROOT} \
  -isystem ${NDK_PATH}/sysroot/usr/include \
  -isystem ${NDK_PATH}/sysroot/usr/include/${HOST}"
export LDFLAGS=-pie
TOOLCHAIN=${NDK_PATH}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}

cat <<EOF >toolchain.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER ${TOOLCHAIN}/bin/${HOST}-gcc)
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN}/${HOST})
EOF

mkdir build

pushd build

#cd {build_directory}
cmake -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
  -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
  ..
make

popd
