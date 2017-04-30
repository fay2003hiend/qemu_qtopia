DOCKER_VOLUME_ARGS:=-v ${CURDIR}:/opt/host_dir

toolchain:
	-mkdir build
	docker build -f Dockerfile.toolchain . -t qemu_qtopia_toolchain

toolchain_shell: toolchain
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia_toolchain bash -l

kernel: toolchain
	docker build -f Dockerfile.kernel . -t qemu_qtopia_kernel	
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia_kernel cp /root/linux-3.2.88/arch/arm/boot/zImage /opt/host_dir/build/zImage

bash: toolchain
	docker build -f Dockerfile.bash . -t qemu_qtopia_bash
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia_bash cp /root/bash-4.4/bash /opt/host_dir/build/bash

busybox: toolchain
	docker build -f Dockerfile.busybox . -t qemu_qtopia_busybox
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia_busybox cp /root/busybox-inst/busybox /opt/host_dir/build/busybox
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia_busybox cp /root/busybox-inst/initrd.gz /opt/host_dir/build/initrd.gz

busybox_shell: busybox
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia_busybox bash -l

qtextended: toolchain
	docker build -f Dockerfile.qtextended . -t qemu_qtopia

qtextended_shell: qtextended
	docker run -it --rm $(DOCKER_VOLUME_ARGS) qemu_qtopia bash -l

all: kernel bash busybox qtextended
	echo done

docker_clean:
	for /f %%i in ('docker images -q -f "dangling=true"') do docker rmi -f %%i
