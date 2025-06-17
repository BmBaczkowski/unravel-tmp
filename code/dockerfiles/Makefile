# GNU Makefile 

.PHONY: test-docker-r build-docker-r

ENGINE := podman
IMG := rstan:2.32.5

build-docker-r: \
	r-stan/Dockerfile \
	r-stan/r-pkgs.txt \
	r-stan/tex-pkgs.txt
	$(ENGINE) build -t $(IMG) -f $< $(<D)

# command to save docker image
# docker save image:tag | gzip > dockerimage.tar.gz

# test docker container
test-docker-r:
	$(ENGINE) run --rm --user=root \
	-it -v `pwd`:/home/dockeruser $(IMG) bash
