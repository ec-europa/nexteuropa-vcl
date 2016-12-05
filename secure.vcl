sub vcl_recv {
  // If https sticky cookie is set, redirect
  if( req.http.cookie ~ "drupal_stick_to_https" && req.http.X-Forwarded-Proto != "https" ) {
    return(synth(301, "https://"  + req.http.host + req.url ));
  }
  // If urls is sensible, switch protocol
  if( req.http.X-Forwarded-Proto == "http" && req.url ~ "/(ecas|login|logout|register|user)" ) {
    return(synth(301, "https://"  + req.http.host + req.url ));
  }
}

sub vcl_synth {
    if (resp.status == 301 || resp.status == 302) {
        set resp.http.location = resp.reason;
        set resp.reason = "Moved";
        return (deliver);
    }
}
