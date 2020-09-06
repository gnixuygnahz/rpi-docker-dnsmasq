FROM arm64v8/alpine:edge

LABEL maintainer="936269759@qq.com"
# webproc release settings
ENV WEBPROC_VERSION v0.4.0
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/$WEBPROC_VERSION/webproc_0.4.0_linux_arm64.gz
# fetch dnsmasq and webproc binary
RUN apk update 
RUN apk --no-cache add dnsmasq 
RUN apk add --no-cache --virtual .build-deps curl 
RUN curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc 
RUN chmod +x /usr/local/bin/webproc 
RUN apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq

RUN mkdir -p /share/dnsmasq/
COPY dnsmasq.conf /share/dnsmasq/dnsmasq.conf
#run!
ENTRYPOINT ["webproc","--configuration-file","/share/dnsmasq/dnsmasq.conf","--","dnsmasq","--no-daemon"]
