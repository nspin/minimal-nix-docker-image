FROM nixos/nix:2.19.0 as bootstrap

RUN nix-channel --add https://nixos.org/channels/nixos-23.11 nixpkgs && nix-channel --update

COPY bootstrap/ bootstrap/

RUN nix-build bootstrap/ --out-link /tmp/bootstrap-system

FROM scratch

COPY --from=bootstrap --link /tmp/bootstrap-system/root/ /

RUN /nix-support/setup

# HACK
ENV USER=root

# HACK
ENV PATH=/root/.nix-profile/bin

RUN rm -r /nix-support

RUN chmod 1777 /tmp /var/tmp

RUN set -eux; \
    nix-channel --add https://nixos.org/channels/nixos-23.11 nixpkgs; \
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager; \
    nix-channel --update

COPY env/ /tmp/env/

# TODO
# Do this with docker run because otherwise docker run using this image can be
# slow when the VOLUME directive below is present.
RUN d=/tmp/env && bash $d/setup.sh && rm -r $d

# TODO combines with above to make docker run slow.
# VOLUME /nix

WORKDIR /work

# FROM bootstrap
# WORKDIR /work
