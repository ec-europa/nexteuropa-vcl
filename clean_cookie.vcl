sub vcl_recv {
  // remove cookies on static resources
  if (req.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|svg|ico)(\?.*)?$") {
    std.log("Static resources, removing cookie");
    unset req.http.Cookie;
  }
}

sub vcl_backend_response { 
  // for static content
  if (bereq.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|svg|ico)(\?.*)?$") {
    // cache content for 1h
    set beresp.ttl = 1h;
    //  keep stall content for 24h
    set beresp.grace = 24h;
  }
}
