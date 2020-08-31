sub vcl_recv {
    unset req.http.Authorization;
}

sub vcl_backend_response { 
    if (bereq.method == "HEAD" || bereq.method == "GET") {
        if (
            beresp.status == 200 ||
            beresp.status == 301 ||
            beresp.status == 302
        ) {
            if (bereq.url !~ "/+(ecas|logout|reset|user)") {
                // default behavior for request without any cookie :
                if ( 
                    !bereq.http.cookie && 
                    !(bereq.url ~ "^/+status\.php$" ||
                    bereq.url ~ "/+(admin|users?|info|flag)(/+.*)?$" ||
                    bereq.url ~ ".*/+a(jax|hah)/.*$" ||
                    bereq.url ~ "/+system/+files/+.*$")
                ) {
                    // cache content for 10m;
                    set beresp.ttl = 10m;
                    //  keep stall content for 24h
                    set beresp.grace = 24h;
                    //browser cache
                    set beresp.http.Cache-Control = "public,max-age=600,must-revalidate";
                }

                // for static content
                if (bereq.http.X-FPFIS-Hint ~ ";(DrupalStaticFile|DrupalStaticResource)") {
                    // cache content for 1h
                    set beresp.ttl = 1h;
                    //  keep stall content for 24h
                    set beresp.grace = 24h;
                    //browser cache
                    set beresp.http.Cache-Control = "public,max-age=3600,s-maxage=3600";
                }elseif(bereq.http.X-FPFIS-Hint ~ ";DrupalStaticSitesFile"){
                    // Look for PHP+Drupal specific headers
                    if (beresp.status == 200 && (beresp.http.Cache-Control == "no-cache, must-revalidate, post-check=0, pre-check=0" || beresp.http.X-Drupal-Cache)) {
                        // The file request was handled dynamically -- do not cache it.
                        set beresp.ttl = 0s;
                        set beresp.grace = 0s;
                        set beresp.http.X-FPFIS-Debug = "generated dynamically => not cached; " + bereq.http.X-FPFIS-Debug;
                        // ... and prevent it from setting any cookie.
                        return(deliver);
                    }
                }
            }
        }
        else {
            set beresp.ttl = 15s;
            set beresp.grace = 2m;
        }
        // Don't cache HTTP responses over 1 MiB
        if (std.integer(beresp.http.content-length, 0) > 1048576) {
            set beresp.ttl = 0s;
            set beresp.grace = 0s;
        }
    }
}
sub vcl_hash {
    if (req.http.X-Forwarded-Proto) {
      hash_data(req.http.X-Forwarded-Proto);
    }
}


