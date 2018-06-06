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
 
 ### test-caching-page.vtc
 
 - Test if HTML (non-static) page are correctly cached
 - Test if correct browser caching headers are sent
 
### test-caching-static.vtc
 
 - Test if static files are correctly cached
 - Test if correct browser caching headers are sent

### test-caching-cookie.vtc
 
 - Test if caching is indeed disabled when a auth cookie is set

