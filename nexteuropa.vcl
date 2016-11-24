sub vcl_recv {
  # remove cookies on static resources
  if (req.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|ico)(\?.*)?$") {
        unset req.http.Cookie;
  }
}

sub vcl_backend_response { 
  # for static content
  if (req.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|ico)(\?.*)?$") {
    # cache content for 1h
    set beresp.ttl = 1h;
    # if backend is down, keep serving stall content for 48h
    set beresp.stale_if_error = 48h;
  }
}
