FROM alpine AS build
RUN apk add --no-cache build-base make automake autoconf git pkgconfig glib-dev gtest-dev gtest cmake

WORKDIR /home/optima
RUN git clone --branch branchHTTPserver https://github.com/MirosMazurenko/DevOps3.git
WORKDIR /home/optima/ci-tests

RUN autoconf
RUN ./configure
RUN cmake

FROM alpine
COPY --from=build /home/optima/ci-tests/program /usr/local/bin/program
ENTRYPOINT ["/usr/local/bin/program"]
