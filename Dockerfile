# syntax=docker/dockerfile:1.3
FROM haproxytech/haproxy-alpine:2.7

RUN apk update --no-cache && apk upgrade --no-cache openssl && apk add --no-cache gettext
RUN mkdir -p /etc/codecov/ssl/certs && chown haproxy:haproxy /etc/codecov/ssl/certs && chown haproxy:haproxy /etc/haproxy
COPY --chmod=755 enterprise.sh /usr/local/bin/enterprise.sh
COPY --chown=haproxy:haproxy --chmod=644 config/0-haproxy.conf /etc/haproxy/0-haproxy.conf.template
COPY --chown=haproxy:haproxy --chmod=644 config/1-backends.conf /etc/haproxy/1-backends.conf.template
COPY --chown=haproxy:haproxy --chmod=644 config/2-http.conf /etc/haproxy/2-http.conf.template
COPY --chown=haproxy:haproxy --chmod=644 config/3-ssl.conf /etc/haproxy/3-ssl.conf.template
COPY --chown=haproxy:haproxy --chmod=644 config/routing.map /etc/haproxy/routing.map
RUN chown -R haproxy:haproxy /var/lib/haproxy && mkdir -p /run && chown -R haproxy:haproxy /etc/haproxy && chown -R haproxy:haproxy /run

ENV CODECOV_API_HOST=api
ENV CODECOV_API_PORT=8000
ENV CODECOV_API_SCHEME=http
ENV CODECOV_API_HOST_HEADER="%[req.hdr(Host)]"
ENV CODECOV_RTI_HOST=rti
ENV CODECOV_RTI_PORT=8000
ENV CODECOV_RTI_SCHEME=http
ENV CODECOV_RTI_HOST_HEADER="%[req.hdr(Host)]"
ENV CODECOV_FRONTEND_HOST=frontend
ENV CODECOV_FRONTEND_PORT=8080
ENV CODECOV_FRONTEND_SCHEME=http
ENV CODECOV_FRONTEND_HOST_HEADER="%[req.hdr(Host)]"
ENV CODECOV_GATEWAY_HTTP_PORT=8080
ENV CODECOV_GATEWAY_HTTPS_PORT=8443
ENV CODECOV_GATEWAY_NS1=1.1.1.1
ENV CODECOV_GATEWAY_NS2=1.0.0.1
ARG COMMIT_SHA
ARG VERSION
ENV BUILD_ID $COMMIT_SHA
ENV BUILD_VERSION $VERSION
EXPOSE 8080
EXPOSE 8443
ENTRYPOINT ["/usr/local/bin/enterprise.sh"]

