ssmtp
=====
Mail relay that enforces SSMTP.
- Asynchronous mail queue
- It accepts emails on port 25 and enforces encryption when shipping to preconfigured destination.
- It will only accept emails from ${SSMTP_DOMAIN_FROM} and relay them to ${SSMTP_DOMAIN_TO}.
- Destination mail server is selected based on DNS MX entries.
- Reports metrics to StatsD
Beneath surface you'll find a pre-configured postfix.


environment variables - required
--------------------------------
- SSMTP_DOMAIN_FROM (mydomain - accepted domain from)
- SSMTP_DOMAIN_TO   (relay_domains - accepted domain to)


environment variables - optional with defaults
----------------------------------------------
- STATSD_HOST=localhost (statsd server)
- STATSD_PORT=8125      (statsd port)
- STATSD_PREFIX=None    (statsd prefix/namespace)
- STATSD_MAXUDPSIZE=512 (statsd max size od UDP package)
- STATSD_DELAY=10       (to configure frequency of qshape measurements, align with graphite resolution)
