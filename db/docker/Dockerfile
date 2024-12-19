FROM postgres:15-bookworm

# Set WORKDIR

ENV INSTALLWORKDIR /var/install
RUN mkdir $INSTALLWORKDIR
WORKDIR $INSTALLWORKDIR

# Versions

ENV POSTGIS_VERSION 3
ENV OSM2PGSQL_VERSION 1.11.0
ENV OSMOSIS_VERSION 0.48.3-2
ENV OSMIUM_VERSION 2.20.0
ENV OSMIUM_TOOL_VERSION 1.14.0

# Osmium deps
ENV OSMIUM_DEPS make cmake  g++ libboost-dev libbz2-dev \
      libexpat1-dev libproj-dev libsparsehash-dev \
      ruby ruby-json \
      spatialite-bin zlib1g-dev \
      doxygen graphviz libgdal-dev \
      libboost-program-options-dev libgeos++-dev

ENV OSM2PGSQL_DEPS make cmake g++ libboost-dev libboost-system-dev \
      libboost-filesystem-dev libexpat1-dev zlib1g-dev libpotrace-dev \
      libopencv-dev libbz2-dev libpq-dev libproj-dev lua5.3 liblua5.3-dev \
      pandoc nlohmann-json3-dev pyosmium

RUN \
    # install dependencies
    apt update && apt install -y --no-install-recommends \
      # utils
      wget \ 
      git \
      unzip \
      software-properties-common \
      # osm2psql
      ${OSM2PGSQL_DEPS} \
      # osmium
      ${OSMIUM_DEPS} \
    # postgis && postgresql-pltcl-15 install
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_VERSION} \
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_VERSION}-scripts \
    postgresql-pltcl-15 \
    # osm2pgsql install from github
    && git clone https://github.com/openstreetmap/osm2pgsql.git \
    && cd osm2pgsql \
    && git checkout ${OSM2PGSQL_VERSION} \
    && mkdir build && cd build \
    && cmake .. && make && make install \
    && cd ../.. \
    # libosmium install
    && git clone https://github.com/mapbox/protozero \
    && wget https://github.com/osmcode/libosmium/archive/v${OSMIUM_VERSION}.tar.gz \
    && tar xzvf v${OSMIUM_VERSION}.tar.gz \
    && rm v${OSMIUM_VERSION}.tar.gz \
    && mv libosmium-${OSMIUM_VERSION} libosmium \
    && cd libosmium && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DINSTALL_PROTOZERO=ON .. \
    && make \
    # osmium-tool install
    && cd /var/install \
    && wget https://github.com/osmcode/osmium-tool/archive/v${OSMIUM_TOOL_VERSION}.tar.gz \
    && tar xzvf v${OSMIUM_TOOL_VERSION}.tar.gz \
    && rm v${OSMIUM_TOOL_VERSION}.tar.gz \
    && mv osmium-tool-${OSMIUM_TOOL_VERSION} osmium-tool \
    && cd osmium-tool \
    && mkdir build && cd build \
    && cmake -DOSMIUM_INCLUDE_DIR=/var/install/libosmium/include/ .. \
    && make \
    && mv /var/install/osmium-tool/build/src/osmium /usr/bin/osmium \
    # clean deps
    && rm -rf /var/install/* \
    # install osmosis
    && apt-get update && apt-get install -y --no-install-recommends osmosis=${OSMOSIS_VERSION} -V \
    # then clean
    && apt-get autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
