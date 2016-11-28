sub vcl_backend_response { 
  // for static content
  if (bereq.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|svg|ico)(\?.*)?$") {
    remove beresp.http.Cache-Control;
    // cache content for 1h
    set beresp.ttl = 1h;
    //  keep stall content for 24h
    set beresp.grace = 24h;
    //browser cache
    set beresp.http.Cache-Control = "public,max-age=3600";
  }
}
