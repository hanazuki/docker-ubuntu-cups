# docker-ubuntu-cups

CUPS server with a CUPS-PDF virtual printer

## Usage

### Environment variables
- `CUPS_ADMIN_USERNAME` (default `admin`): username of an lpadmin
- `CUPS_ADMIN_PASSWORD`: its password
- `CUPS_LOG_LEVEL` (default `warn`): `LogLevel` in `cupsd.conf(5)`
### Volumes
- `/var/spool/cups-pdf/ANONYMOUS`: Documents sent to the printer `PDF` is stored in this volume.
### Ports
- `631/tcp`: CUPS listens to this port. WebInterface is enabled by default.
### Logs
`ErrorLog` and `PageLog` are sent to stderr.
### Entrypoint hooks
Executable files in `/docker-entrypoint.d` are invoked just before `cupsd` is started using `run-parts`.
