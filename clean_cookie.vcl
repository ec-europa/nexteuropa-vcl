sub vcl_recv {
  // remove cookies on static resources
  if ( req.url ~ "(?i)\.(bz2|css|eot|gif|gz|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)(\?(itok=)?[a-z0-9_=\.\-]+)?$"
       && 
       req.url !~ "/system/storage/serve"
    ) {
    std.log("Static resources, removing cookie");
    unset req.http.Cookie;
  }
}
