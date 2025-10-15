# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
# GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000 \
      BUILD_SRC=netbirdio/netbird.git \
      BUILD_ROOT="/go/netbird/client" \
      GO_VERSION=1.25
  ARG BUILD_BIN=${BUILD_ROOT}/netbird

# :: FOREIGN IMAGES
  FROM 11notes/util AS util

# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝
# :: NETBIRD
  FROM 11notes/go:${GO_VERSION} AS build
  ARG APP_VERSION \
      BUILD_SRC \
      BUILD_ROOT \
      BUILD_BIN

  RUN set -ex; \
    apk --update --no-cache add \
      libcap;

  RUN set -ex; \
    eleven git clone ${BUILD_SRC} v${APP_VERSION}; \
    sed -i 's/"development"/"v'${APP_VERSION}'"/' /go/netbird/version/version.go;

  RUN set -ex; \
    cd ${BUILD_ROOT}; \
    eleven go build ${BUILD_BIN} main.go; \
    eleven distroless ${BUILD_BIN};

# :: ENTRYPOINT
  FROM 11notes/go:${GO_VERSION} AS entrypoint
  COPY ./build /
  ARG BUILD_BIN=/go/netbird/entrypoint

  RUN set -ex; \
    cd /go/netbird; \
    eleven go build ${BUILD_BIN} main.go; \
    eleven distroless ${BUILD_BIN};

# :: FILE SYSTEM
  FROM alpine AS file-system
  COPY --from=util / /
  ARG APP_ROOT

  RUN set -ex; \
    eleven mkdir /distroless${APP_ROOT}/{etc};


# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: HEADER
  FROM 11notes/alpine:stable

  # :: default arguments
    ARG TARGETPLATFORM \
        TARGETOS \
        TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID \
        APP_NO_CACHE

  # :: default environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: app specific environment
    ENV NB_ENTRYPOINT_SERVICE_TIMEOUT="10" \
        NB_ENTRYPOINT_LOGIN_TIMEOUT="5" \
        HOME=${APP_ROOT}/etc \
        NB_STATE_DIR=${APP_ROOT}/etc \
        NB_CONFIG=${APP_ROOT}/etc/client.json \
        NB_USE_NETSTACK_MODE="true" \
        NB_ENABLE_NETSTACK_LOCAL_FORWARDING="true" \
        NB_DAEMON_ADDR="unix:///run/netbird.sock" \
        USER=${APP_UID}

  # :: multi-stage
    COPY --from=build /distroless/ /
    COPY --from=file-system --chown=${APP_UID}:${APP_GID} /distroless/ /
    COPY --from=entrypoint /distroless/ /

# :: PERSISTENT DATA
  VOLUME ["${APP_ROOT}/etc"]

# :: EXECUTE
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/usr/local/bin/entrypoint"]