sub vcl_recv {
  // remove cookies on static resources
  if (req.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|ico)(\?.*)?$") {
    unset req.http.Cookie;
    // if backend is down/slow, keep serving stall content for 24h
    //set req.grace = 24h;
  }
}

sub vcl_backend_response { 
  // for static content
  if (beresp.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|ico)(\?.*)?$") {
    // cache content for 1h
    set beresp.ttl = 1h;
    //  keep stall content for 24h
    set beresp.grace = 24h;
  }
}
