# Alpine Docker Image: PHP 7.4 + NGINX

Dockerimage for hosting standart PHP Applications or static html sites with PHP 7.4 + NGINX.
Includes Imagick Lib for Image manipulation and composer (The most used PHP-Project dependency manager)
The container can be used directly, but is designed to run behind a proxy like Traefik, which also takes care of the SSL/TLS encryption.

----

## Configuration:

The configuration is done via environment variables and can be passed e.g. via the docker cli or in a docker-compose file. For the full list of variables see ".env.sample".

The most important variables:

| Variable                     | Description                                                  | Default        |
| ---------------------------- | ------------------------------------------------------------ | -------------- |
| TZ                           | (Timezone)                                                   | Europe/Berlin  |
| PHP_MAX_EXEC_TIME            | Set max execution time for PHP scripts                       | 90 (sec)       |
| PHP_POST_AND_UPLOAD_MAX_SIZE | Set Max Post and Upload Filesize Limit for PHP and Max Upload limit in NGINX | 10M            |
| PHP_MEMORY_LIMIT             | Set max memory Limit for PHP (RAM)                           | 128M           |
| PORT                         | Set listen port for nginx                                    | 80             |
| DOCUMENT_ROOT                | Set webfoot for nginx                                        | /var/www/html/ |
| SERVER_NAME                  | Set nginx Server Name                                        | pjirlip.eu =)  |


## Usage: (Directly from prebuild Image on GitHub)

1. copy the "docker-compose.prod.yaml" into desired directory as "docker-compose.yml". e.g. /opt/docker/myService/docker-compose.yml
2. copy the "env.sample" into the same directory as .env and adjust/remove variables. e.g. /opt/docker/myService/.env
3. the docker-compose file contains a host-volume-mount on "./webroot/". Accordingly, the directory must be created. Then copy the desired files to be output from the web server to it. e.g.:

```bash
mkdir -P /opt/docker/myService/webroot/
mv index.php /opt/docker/myService/webroot/
```
3. run `docker-compose up -d`.

The container listens on port 80 (default). The web server can now be reached locally at http://localhost:80.

The container is designed to run behind a proxy/load balancer in production mode. This should also take care of SSL/TLS encryption for a publicly accessible service.

I use [Taerifik](https://doc.traefik.io/traefik/) for this (and can recommend this accordingly).
[See Traefik Docs for easy configuration in using Docker together with Let's Encrypt as CA](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-tls/)