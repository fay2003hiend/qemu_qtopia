DOCKER_VOLUME_ARGS:=-v ${CURDIR}:/opt/host_dir

toolchain:
	-mkdir build
	docker build -f Dockerfile.toolchain . -t nbp_toolchain

toolchain_shell: toolchain
	docker run -it --rm $(DOCKER_VOLUME_ARGS) nbp_toolchain bash -l

kernel: toolchain
	docker build -f Dockerfile.kernel . -t nbp_kernel	
	docker run -it --rm $(DOCKER_VOLUME_ARGS) nbp_kernel cp /root/linux-3.2.88/arch/arm/boot/zImage /opt/host_dir/build/zImage

bash: toolchain
	docker build -f Dockerfile.bash . -t nbp_bash
	docker run -it --rm $(DOCKER_VOLUME_ARGS) nbp_bash cp /root/bash-4.4/bash /opt/host_dir/build/bash

busybox: toolchain
	docker build -f Dockerfile.busybox . -t nbp_busybox
	docker run -it --rm $(DOCKER_VOLUME_ARGS) nbp_busybox cp /root/busybox-inst/busybox /opt/host_dir/build/busybox
	docker run -it --rm $(DOCKER_VOLUME_ARGS) nbp_busybox cp /root/busybox-inst/initrd.gz /opt/host_dir/build/initrd.gz

busybox_shell: busybox
	docker run -it --rm $(DOCKER_VOLUME_ARGS) nbp_busybox bash -l

all: toolchain kernel bash busybox
	echo done

docker_clean:
	for /f %%i in ('docker images -q -f "dangling=true"') do docker rmi -f %%i
