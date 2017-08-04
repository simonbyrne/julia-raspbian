 #!/bin/sh

JULIA_VER=0.6.0
EMAIL=juliapro@juliacomputing.com

wget -c https://github.com/JuliaLang/julia/releases/download/v$JULIA_VER/julia-$JULIA_VER.tar.gz
mkdir -p julia/lib/julia
tar -zxvf julia-$JULIA_VER.tar.gz -C julia --strip-components=1
gcc -shared /usr/lib/arm-linux-gnueabihf/libsuitesparseconfig.a -o julia/lib/julia/libsuitesparseconfig.so

cp Make.user julia

cd julia && make -j2 binary-dist


rm -fr julia-$JULIA_VER julia_* && \
    tar zxf julia-$JULIA_VER-Linux-arm.tar.gz && \
    cd julia-$JULIA_VER && \
    mv LICENSE.md share/doc/julia/LICENSE.md && \
    rm -f lib/julia/libpcre2-posix.so* && \
    rm -f lib/julia/libstdc++.so* && \
    rm -f bin/*-debug* lib/*-debug* lib/julia/*-debug* && \
    rm -fr libexec && \
    rm -f lib/julia/libccalltest* && \
    mkdir usr && \
    mv bin include lib share usr && \
    tar  cvf ../julia-$JULIA_VER.tar * && \
    cd .. && \
    rm -fr julia-$JULIA_VER && \
    fakeroot alien -d --generate julia-$JULIA_VER.tar && \
    cp -f ../control julia-$JULIA_VER/debian && \
    cd julia-$JULIA_VER && \
    debuild --no-lintian
