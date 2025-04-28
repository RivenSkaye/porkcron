FROM python:3.10-alpine

COPY ../porkcron.py /usr/local/bin/porkcron
RUN chmod +x /usr/local/bin/porkcron

RUN mkdir -p /etc/porkcron/crontabs
COPY ../crontabs/* /etc/porkcron/crontabs/
RUN cat /etc/porkcron/crontabs/* | sed 's/ root / /g' > /etc/crontabs/root

CMD [ "crond", "-f" ]
