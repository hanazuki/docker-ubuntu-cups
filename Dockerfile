FROM ubuntu:bionic

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        cups printer-driver-cups-pdf && \
    apt-get clean && find /var/lib/apt/lists -type f -delete

COPY cupsd.conf cups-files.conf /etc/cups/

RUN cupsd -f & pid=$! && \
    while test ! -S /run/cups/cups.sock; do sleep 1; done && \
    lpadmin -p PDF -v cups-pdf:/ -m lsb/usr/cups-pdf/CUPS-PDF_opt.ppd -E && \
    while kill "$pid" 2>/dev/null; do sleep 1; done

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh

EXPOSE 631
VOLUME ["/var/spool/cups-pdf/ANONYMOUS"]
ENTRYPOINT ["/docker-entrypoint.sh"]
