# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "librdkafka_build"
version = v"0.1.0"

# Collection of sources required to build librdkafka_build
sources = [
    "https://github.com/edenhill/librdkafka/archive/v2.5.3.tar.gz" =>
    "eaa1213fdddf9c43e28834d9a832d9dd732377d35121e42f875966305f52b8ff",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd librdkafka-2.5.3/
./configure 
make
cp src/librdkafka*.so $prefix/ || true
cp src/librdkafka*.so.1 $prefix/ || true
cp src/librdkafka*.dll $prefix/ || true
cp src/librdkafka*.dylib $prefix || true
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    # MacOS(:x86_64),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "librdkafka", :librdkafka_so)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

