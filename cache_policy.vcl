sub vcl_backend_response { 
  // for static content
  if ( bereq.url ~ "(?i)\.(bz2|css|eot|gif|gz|html?|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)(\?(itok=)?[a-z0-9_=\.\-]+)?$"
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
