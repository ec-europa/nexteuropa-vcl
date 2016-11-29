sub vcl_recv {
  // remove cookies on static resources
  if (req.url ~ "(?i)\.(css|js|jpg|jpeg|gif|png|svg|ico)(?[wd=.-]+)?$") {
    std.log("Static resources, removing cookie");
    unset req.http.Cookie;
  }
}
