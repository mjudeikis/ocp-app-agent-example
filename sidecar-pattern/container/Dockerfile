FROM alpine:latest
RUN mkdir -p /usr/local/ /newrelic
RUN chmod 777 /newrelic
ADD newrelic /usr/local/newrelic
ADD sleep.sh /usr/local/sleep.sh
CMD ["/bin/sh","/usr/local/sleep.sh"]