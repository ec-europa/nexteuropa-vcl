sub vcl_recv {
  // remove cookies on static resources
  if ( req.url ~ "(?i)\.(bz2|css|eot|gif|gz|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)$"
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

sub vcl_backend_response {
  // if we know which cookie drupal should set : 
  // and we can't find it in what the backend wants :
  if( beresp.http.set-cookie !~ "SESS") {
    std.log("Non session cookies removed");
    // drop it (it can be done in JS)
    unset beresp.http.set-cookie;
  }
}
