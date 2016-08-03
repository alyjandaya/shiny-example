FROM r-base:latest

MAINTAINER Alyjan Daya "adaya@atlassian.com"

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev


# Download and install libssl 0.9.8
RUN wget --no-verbose http://security.debian.org/pool/updates/main/o/openssl/libssl1.0.0-dbg_1.0.1e-2+deb7u20_kfreebsd-amd64.deb \
&& dpkg -i libssl1.0.0-dbg_1.0.1e-2+deb7u20_kfreebsd-amd64.deb \
&& rm -f libssl1.0.0-dbg_1.0.1e-2+deb7u20_kfreebsd-amd64.deb


# Install the latest postgresql
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --force-yes \
        postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 && \
    /etc/init.d/postgresql stop

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny','shinyjs','DBI','digest'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('RPostgreSQL'), repos='http://cran.rstudio.com/')"

COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY /myapp/* /srv/shiny-server/

EXPOSE 80

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

