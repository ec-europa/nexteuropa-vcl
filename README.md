# nexteuropa-vcl
Base NextEuropa VCL configuration

## Information
- Basic requirements (vmod) are mentioned in testing.vcl
- This VCL is included from the processed salt recipe : https://github.com/ec-europa/nexteuropa-vcl

## Deploy
This VCL is tested and deployed on https://docs.fpfis.eu/docker-images/varnish-ne/

## Usage

### Drupal 7 NextEuropa projects

The following example files allow you to setup your Drupal 7 NextEuropa project
locally with Varnish. Place both the docker-compose.yml and config.yaml file in
the root folder of your project.

#### Files

<details>
  <summary><b>docker-compose.yml</b></summary>

```yml
version: '2'
services:
  web:
    image: fpfis/httpd-php-dev:5.6
    working_dir: ${PWD}
     ports:
       # This makes your website available on port 80.
       - 80:8080
    volumes:
      - ${PWD}:${PWD}
    environment:
      DOCUMENT_ROOT: ${PWD}/build
  mysql:
    image: percona/percona-server:5.6
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
    volumes:
      - mysql:/var/lib/mysql
  varnish:
    image: fpfis/varnish-ne:4.1
    environment:
      # Comes from settings.php user:password in 64auth:
      # $conf['nexteuropa_varnish_request_user'] = "user";
      # $conf['nexteuropa_varnish_request_password'] = "password";
      - VARNISH_PURGE_KEY=dXNlcjpwYXNzd29yZA==
    volumes:
      # This file is responsible for generating your backends and directors in
      # Varnish. Documentation on this file can be found at the base image:
      # https://github.com/fpfis/varnish#configuration
      - ./config.yaml:/config.yaml
    ports:
      # This makes your Varnish instance available on port 8080.
      - 8080:8086

volumes:
  mysql:
```

</details>

<details>
  <summary><b>config.yaml</b></summary>

```yaml
# Documentation on this file can be found at the base image:
# https://github.com/fpfis/varnish#configuration
varnish:
  sites:
    # Site name is used as application tag and is used for purging:
    # https://github.com/fpfis/varnish/blob/master/scripts/directors.vcl.jinja2#L38
    # https://github.com/ec-europa/nexteuropa-vcl/blob/production/content_purge.vcl#L51
    drupal:
      # Subfolder if you have multisite on a single varnish
      path: /build
      # If your website is behind basic authentication run:
      # echo -n user:password | base64
      base64auth: --> insert base64auth string here
      # The instance(s) where your site can be found.
      # Is used to generate the backends and directors for Varnish.
      nodes:
        - host: web
          port: 8080
```

</details>

#### Installation

After you have placed these two files in the root of your project you can setup
your website with the following commands:

```bash
docker-compose up -d
docker-compose exec web composer install
# Given that you are working on a Drupal 7 NextEuropa project and you have
# provided the build.develop.props file with correct credentials
# and connection settings.
docker-compose exec web ./toolkit/phing build-platform build-subsite-dev install-clone
```

After this your site should be available on port 80 <u>without</u> Varnish. And
it should be available on port 8080 <u>with</u> Varnish.

#### NextEuropa Varnish integration

If you want to connect the nexteuropa_varnish module to your Varnish you have to
add the following settings to your settings.php:

<details>
  <summary><b>settings.php</b> (partial)</summary>

```php
# Default value.
$conf['nexteuropa_varnish_request_method'] = "PURGE";
# This comes from your docker-compose.yml file for the varnish service.
$conf['nexteuropa_varnish_http_targets'] = array ("http://varnish:8086");
# Site name is used as application tag, check config.yaml file for fpfis/varnish-ne and is used for purging:
# https://github.com/fpfis/varnish/blob/master/scripts/directors.vcl.jinja2#L38
# https://github.com/ec-europa/nexteuropa-vcl/blob/production/content_purge.vcl#L51
$conf['nexteuropa_varnish_tag'] = "drupal";
# Also used in your docker-compose.yml file within VARNISH_PURGE_KEY in base64auth format.
$conf['nexteuropa_varnish_request_user'] = "user";
$conf['nexteuropa_varnish_request_password'] = "password";
# Default value.
$conf['nexteuropa_varnish_http_timeout'] = "30";
```

</details>

#### Debugging

If you want to debug a certain url in Varnish you can run:
```bash
# Enter your Varnish container with bash
docker-compose exec varnish bash
# Example: only listen for requests of the frontpage at "/".
varnishlog -q 'ReqURL eq "/"'
```

Then visit your page and varnishlog will show you the request.


