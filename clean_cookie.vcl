sub vcl_recv {
    if(
        req.method == "HEAD"
        ||
        req.method == "GET"
    ) {
        // remove cookies on static resources
        if (
            req.url ~ "(?i)\.(bz2|css|eot|gif|gz|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)$"
            &&
            req.url !~ "/system/storage/serve"
        ) {
            std.log("Static resources, removing cookie");
            unset req.http.Cookie;
        }

        // Clean every cookie, except NO_CACHE and Drupal
        if ( req.http.cookie && req.http.X-FPFIS-Drupal-Session ) {
            cookie.parse(req.http.cookie);
            // remove every cookie that's not drupal related
            cookie.filter_except("NO_CACHE," + req.http.X-FPFIS-Drupal-Session);
            set req.http.cookie = cookie.get_string();
        }
        if (req.http.cookie == "") {
            unset req.http.cookie;
        }
    }
}
/*
sub vcl_backend_response {
    // Only allow POST request to set cookies
    if(bereq.method != "POST" && bereq.url !~ "/ecas.*?$") {
        unset beresp.http.set-cookie;
    }
}
*/
