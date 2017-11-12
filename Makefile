CHROOT_SUITE=trusty
CHROOT_DIR=chroot

BUILD_DIR=build

CEF_DIR=cef
CEF_BRANCH=3202

CEFPYTHON_DIR=cefpython
CEFPYTHON_REPO=https://github.com/cztomczak/cefpython
CEFPYTHON_BRANCH=cefpython57
CEF_VERSION=57.0

DOCKER_CONTAINER_TAG=cefpython-builder
DOCKER_CONTAINER_VERSION=latest
CEF_VOLUMES=-v `pwd`/${CEF_DIR}:/src -v `pwd`/${BUILD_DIR}:/src/${BUILD_DIR}
CEFPYTHON_VOLUMES=-v `pwd`/${CEFPYTHON_DIR}:/src -v `pwd`/${BUILD_DIR}:/src/${BUILD_DIR}
CEFPYTHON_CONTAINER_SUBCOMMAND=docker run -it ${CEFPYTHON_VOLUMES} ${DOCKER_CONTAINER_TAG}:${DOCKER_CONTAINER_VERSION} bash -c
CEF_CONTAINER_SUBCOMMAND=docker run -it ${CEF_VOLUMES} ${DOCKER_CONTAINER_TAG}:${DOCKER_CONTAINER_VERSION} bash -c

all: cefpython3

cef: docker-image
	git clone https://bitbucket.org/chromiumembedded/cef || true
	${CEF_CONTAINER_SUBCOMMAND} "cd ${BUILD_DIR} && python ../tools/automate/automate-git.py --download-dir=. --branch=${CEF_BRANCH} --x64-build --force-update --no-build --no-distrib"
	GN_DEFINES="is_official_build=true use_sysroot=true use_allocator=none symbole_level=1" ${CEF_CONTAINER_SUBCOMMAND} "cd ${BUILD_DIR} && python ../tools/automate/automate-git.py --download-dir=. --branch=${CEF_BRANCH} --x64-build --force-build --build-target=cefsimple"

cefpython3: src docker-image
	${CEFPYTHON_CONTAINER_SUBCOMMAND} "cd ${BUILD_DIR} && python ../tools/automate.py --build-cef"
	${CEFPYTHON_CONTAINER_SUBCOMMAND} "cd ${BUILD_DIR} && python ../tools/build.py ${CEF_VERSION}"

docker-image:
	docker build . -t ${DOCKER_CONTAINER_TAG}

src:
	test -d ${CEFPYTHON_DIR} || git clone ${CEFPYTHON_REPO} ${CEFPYTHON_DIR}
	cd ${CEFPYTHON_DIR} && git reset --hard origin/${CEFPYTHON_BRANCH}
	cp patches/cef/*.patch ${CEFPYTHON_DIR}/patches

	for patch in `pwd`/patches/cefpython/*.patch ; do \
		patch -d `pwd`/${CEFPYTHON_DIR} -p1 < $$patch ; \
	done
