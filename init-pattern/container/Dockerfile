FROM alpine:latest
RUN mkdir -p /usr/local/ /newrelic /newrelic-config
ADD newrelic /usr/local/newrelic
RUN chmod -R 777 /newrelic /newrelic-config /usr/local/newrelic
ADD sleep.sh /usr/local/sleep.sh
CMD ["/bin/sh","/usr/local/sleep.sh"]