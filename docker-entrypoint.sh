#!/bin/bash
set -eu

: ${CUPS_ADMIN_USERNAME:=admin}
: ${CUPS_LOG_LEVEL:=warn}

if [[ -z $CUPS_ADMIN_PASSWORD ]]; then
    echo 'Empty $CUPS_ADMIN_PASSWORD.' >&2
    exit 1
fi

if ! id "$CUPS_ADMIN_USERNAME" >/dev/null 2>&1; then
    useradd -m -G lpadmin -s /usr/sbin/nologin "$CUPS_ADMIN_USERNAME"
    echo "$CUPS_ADMIN_USERNAME:$CUPS_ADMIN_PASSWORD" | chpasswd
fi

sed -i /etc/cups/cupsd.conf -e "s|^LogLevel .*$|LogLevel $CUPS_LOG_LEVEL|"
chmod 1777 /var/spool/cups-pdf/ANONYMOUS

if [[ -d /docker-entrypoint.d ]]; then
    run-parts --exit-on-error /docker-entrypoint.d
fi

if [[ ${1-} == /* ]]; then
    exec "$@"
fi

exec cupsd -f "$@"
