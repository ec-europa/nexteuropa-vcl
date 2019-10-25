sub vcl_recv {
    if(
        req.method == "HEAD"
        ||
        req.method == "GET"
    ) {
        if (req.http.X-FPFIS-Hint ~ ";(DrupalStaticSitesFile|DrupalStaticResource)") {
            std.log("Hint DrupalSiteFile, removing cookie from vcl_backend_response");
            // We still unset cookies, because typically, dynamically generated
            // files under sites/*/files do not rely on authentication
            unset req.http.cookie;
        }
    
        // Clean every cookie, except NO_CACHE and Drupal
        if ( req.http.cookie && req.http.X-FPFIS-Drupal-Session ) {
            cookie.parse(req.http.cookie);
            // remove every cookie that's not drupal related
            cookie.filter_except("drupal_stick_to_https,NO_CACHE," + req.http.X-FPFIS-Drupal-Session);
            set req.http.cookie = cookie.get_string();
        }
        if (req.http.cookie == "") {
            unset req.http.cookie;
        }
    }
}

/*
 * Called after the response headers have been successfully retrieved from the backend.
 */
sub vcl_backend_response {
    if (bereq.http.X-FPFIS-Hint ~ ";DrupalStaticSitesFile") {
        // Prevent setting any cookie. This may occur since:
        // 1 - we remove cookies upon reception of requests for Drupal files
        // 2 - triggered dynamic executions may want to enforce some default cookies
        // 3 - which we do not want since they may override already set
        // cookies (e.g. language preference or worse, session cookie).
        std.log("Hint DrupalStaticSitesFile, removing cookie from vcl_backend_response");
        unset beresp.http.Set-Cookie;
    }
}
