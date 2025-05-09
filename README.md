# porkcron

Automatically renew SSL certificate for your Porkbun domain.

## 📌 About

`porkcron` is a simple alternative to [certbot][1].
If you own a domain registered by [Porkbun][2], they offer you a [free SSL certificate][3] issued by [Let's Encrypt][4].
So instead of getting it from scratch yourself, you can periodically download the certificate using the [Porkbun API][5].
`porkcron` is designed to automate this process.
It can be run as a [systemd timer][6] or in a Docker container.

## 📦 Install

First, you need to generate the API keys following [this guide][7].
Do not forget to enable the API access for your domain!

When you're ready, clone the repository somewhere on your server:

```shell
git clone https://github.com/tmzane/porkcron
```

Take a look at the `.env.example` file.
It contains all the environment variables used by `porkcron`.
Rename it to `.env` and fill it with the values you got earlier.

| Name             | Description                         | Required | Default                                |
|------------------|-------------------------------------|:--------:|----------------------------------------|
| DOMAIN           | your Porkbun domain(s)              | yes      | -                                      |
| API_KEY          | your Porkbun API key                | yes      | -                                      |
| SECRET_KEY       | your Porkbun API secret key         | yes      | -                                      |
| API_URL          | the Porkbun API address             | no       | https://api.porkbun.com/api/json/v3    |
| CERTIFICATE_PATH | the path to save the certificate to | no       | /etc/porkcron/{domain}/certificate.pem |
| PRIVATE_KEY_PATH | the path to save the private key to | no       | /etc/porkcron/{domain}/private_key.pem |

Note the `{domain}` placeholder in the paths.
It will be automatically replaced with your domain.
You can use the placeholder in non-default paths as well.

`porkcron` can also work with multiple domains at once.
You can set `DOMAIN` to a comma-separated list of domains.
In this case, both `CERTIFICATE_PATH` and `PRIVATE_KEY_PATH` must contain the `{domain}` placeholder.

Once you have filled in all the values, you can proceed to choosing the installation method.

### Using systemd

Run the following commands:

```shell
cd systemd
chmod +x install.sh
./install.sh
```

This will install the script in `/usr/local/bin` and enable the timer.
The first run will be triggered immediately, check the log to make sure it was successful:

```shell
systemctl status porkcron.service
```

### Using Docker

Run the following commands:

```shell
cd docker
docker compose up
```

This will create the `porkcron` container and download the certificate bundle into the `ssl` volume.

### Using cron

If you're using FreeBSD or any other OS that doesn't come with systemd timers, but that does provide cron you can use the following:

```sh
cd standalone
chmod +x install.sh
./standalone/install.sh
```

> [!WARNING]
> If you are using BusyBox cron or another "embedded" cron implementation, it might not read `/etc/cron.d` by default. In this case
> you will have to adjust the install script, symlink the directory, or add the proper entries to your flavor of cron yourself.
>
> You can find an example approach to doing this in [The Dockerfile][10] which uses the Python overlay on the Alpine image.

It ensures the install script is executable if git didn't preserve the executable bit, before running it. It will install a wrapper
script in `/usr/local/bin` that reads the .env file and put corresponding entries in `/etc/cron.d`. If you prepared a .env file in
advance, it will trigger the first run immediately. Otherwise it'll tell you where to put the file so you can run it later.

The corresponding crontabs will run weekly and on every reboot. It does assume the `@reboot` extension is available in your flavor
of cron, as there is no equivalent specifiable time expression for it. The weekly job is defined as `0 0 * * 1` for compatibility.

### Changing the run schedule

By default, the script is run once per week,
which is plenty since the certificate is valid for 3 months.
You can change the schedule by modifying `systemd/porkcron.timer` (for systemd) or `crontabs/porkcron.weekly` (for Docker and cron).

### Configuring a web server

This repository contains an example for the [nginx][8] web server,
but you can use `porkcron` with the one of your choice.
See [Mozilla's SSL config generator][9] for a quick start.

For nginx, see `nginx/nginx.conf` for a minimal SSL-ready config.
You should modify it for your needs.

If you're using systemd, copy the modified config to `/etc/nginx/conf.d` and reload nginx.
Then uncomment the `ExecStartPost` line in `systemd/porkcron.service`.

If you're using Docker, just uncomment the `nginx` section in `docker/compose.yml`.

Finally, reinstall `porkcron` to apply the changes and try hitting `https://your.domain`.
The rest is up to you, happy hacking!

[1]: https://certbot.eff.org
[2]: https://porkbun.com
[3]: https://kb.porkbun.com/article/71-how-your-free-ssl-certificate-works
[4]: https://letsencrypt.org
[5]: https://porkbun.com/api/json/v3/documentation
[6]: https://wiki.archlinux.org/title/systemd/Timers
[7]: https://kb.porkbun.com/article/190-getting-started-with-the-porkbun-dns-api
[8]: https://nginx.org
[9]: https://ssl-config.mozilla.org
[10]: https://github.com/tmzane/porkcron/blob/main/docker/Dockerfile
