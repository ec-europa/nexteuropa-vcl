sub vcl_backend_response { 
    if(
        (bereq.method == "HEAD" || bereq.method == "GET")
        &&
        beresp.status == 200
        ) {
        // default behavior for request without any cookie :
        if ( !bereq.http.cookie ) {
            // cache content for 10m;
            set beresp.ttl = 10m;
            //  keep stall content for 24h
            set beresp.grace = 24h;
            //browser cache
            set beresp.http.Cache-Control = "public,max-age=600,s-maxage=60";
        }

        // for static content
        if ( bereq.url ~ "(?i)\.(bz2|css|eot|gif|gz|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)$"
           &&
           bereq.url !~ "/system/storage/serve"
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
