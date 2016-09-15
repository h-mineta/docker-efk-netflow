FROM alpine:3.4
MAINTAINER h-mineta <h-mineta@0nyx.net>

RUN set -x \
	&& apk upgrade --update \
	&& apk add \
		bash \
		ca-certificates \
		'ruby=2.3.1-r0' \
		ruby-irb \
		geoip \
	\
	&& apk add --virtual .build-deps \
		ruby-dev \
		build-base \
		geoip-dev \
	\
	&& echo 'gem: --no-document' >> /etc/gemrc \
	&& gem install fluentd \
	&& adduser -D -g '' -u 1000 -h /usr/local/fluent fluent \
	&& chown -R fluent:fluent /usr/local/fluent

USER fluent
WORKDIR /usr/local/fluent

ENV PATH /usr/local/fluent/.gem/ruby/2.3.0/bin:$PATH
ENV GEM_PATH /usr/local/fluent/.gem/ruby/2.3.0:$GEM_PATH

RUN set -x \
	&& mkdir -p etc log plugins \
	&& echo 'gem: --user-install --no-document' >> ~/.gemrc \
	&& fluent-gem install \
		fluent-plugin-elasticsearch \
		fluent-plugin-multiprocess \
		fluent-plugin-netflow \
		fluent-plugin-netflow-multiplier \
		fluent-plugin-geoip \
		fluent-plugin-flowcounter

USER root
RUN set -x \
	# cleaning
	&& cd / \
	&& apk del --purge .build-deps \
	&& rm -rf /tmp/* \
	&& rm -rf /var/cache/apk/*

USER fluent
ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="/usr/local/fluent/etc/fluent.conf"

CMD exec fluentd -c $FLUENTD_CONF $FLUENTD_OPT
EXPOSE 24220 24224 5141 5142 5143 5144
