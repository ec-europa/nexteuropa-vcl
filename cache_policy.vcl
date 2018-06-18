sub vcl_backend_response { 
    if (bereq.method == "HEAD" || bereq.method == "GET") {
        if (beresp.status ~ "(200|30([1-3]|[7-8]))") {
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
                if ( 
                    (bereq.url ~ "(?i)\.(bmp|bz2|(doc|xls|ppt)x?|mkv|css|eot|gif|gz|html?|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|txz|ttf|woff2?|xml|xz|zip)(\?.*|)$" && bereq.url !~ "/+system/+") ||
                    bereq.url ~ "^(?:misc|modules|themes|sites/+all|sites/+[^/]+/(?:themes|modules))/"
                ) {
                    // cache content for 1h
                    set beresp.ttl = 1h;
                    //  keep stall content for 24h
                    set beresp.grace = 24h;
                    //browser cache
                    set beresp.http.Cache-Control = "public,max-age=3600,s-maxage=3600";
                }
            }
        }
        else {
            set beresp.ttl = 15s;
            set beresp.grace = 2m;
        }
        # Don't cache HTTP responses over 1 MiB
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
