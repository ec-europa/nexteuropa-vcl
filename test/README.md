# Testing

## How-to

You must have varnishtest installed on your machine with the following vmods :

 - vsthrottle
 - drupal7

Then from the root project folder, run :

```sh
./test.sh
```

or ( verbose )

```sh
varnishtest -vp vcl_dir=$(pwd) test/*.vtc
```

## Test cases

### https-redirect-loop.vtc

 - Test if there's any redirect loop when using a 443 through synth redirect using c4d's config
 - Test that we're redirect properly

### test-drupal7-cookie.vtc

 - Test if the Drupal 7 cookie is correctly generated based on path + host


