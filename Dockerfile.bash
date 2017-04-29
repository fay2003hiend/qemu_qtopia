FROM nbp_toolchain

WORKDIR /root

RUN wget ftp://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz
RUN for i in `seq -w 1 999`; do wget ftp://ftp.gnu.org/gnu/bash/bash-4.4-patches/bash44-${i}; [ $? -ne 0 ] && break; done
RUN tar zxf bash-4.4.tar.gz

WORKDIR /root/bash-4.4

RUN for i in `seq -w 1 999`; do patch -p0 < ../bash44-${i}; [ $? -ne 0 ] && break; done

ENV PATH="/opt/arm-2014.05/bin:${PATH}"
ENV CC arm-none-linux-gnueabi-gcc

RUN ./configure --enable-static-link \
--prefix=/root/build_bash \
--host=arm-none-linux-gnueabi \
--enable-static-link \
--without-bash-malloc

RUN make -j 8
RUN arm-none-linux-gnueabi-strip bash
