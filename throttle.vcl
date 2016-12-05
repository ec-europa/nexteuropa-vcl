sub vcl_recv {
    # Varnish will set client.identity for you based on client IP.

    if ( 
      req.http.X-FPFIS-Is-Bot == "yes" 
        && 
      req.url !~ "(?i)\.(bz2|css|eot|gif|gz|ico|jpe?g|js|mp3|ogg|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)$"  
        &&
      vsthrottle.is_denied(req.http.user-agent, 5, 10s)
    ) {
      # Bot has exceeded 5 reqs per 10s
      return (synth(429, "Too Many Requests"));
    }

    # Only allow a few POST/PUTs per client for external traffic.
    if (req.http.Client-IP && (req.method == "POST" || req.method == "PUT")) {
        if (vsthrottle.is_denied("rw" + req.http.Client-IP, 10, 10s)) {
            return (synth(429, "Too Many Requests"));
        }
    }
}
