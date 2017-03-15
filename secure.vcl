acl blacklist {
    "192.168.0.0"/16;
}

sub vcl_recv {
  // Blacklist
  if(req.http.client-ip && std.ip(req.http.client-ip, "0.0.0.0") ~ blacklist) {
    return(synth(403,"Banned"));
  }
  // If https sticky cookie is set, redirect
  if( req.http.cookie ~ "drupal_stick_to_https" && req.http.X-Forwarded-Proto != "https" ) {
    return(synth(301, "https://"  + req.http.host + req.url ));
  }
  // If urls is sensible, switch protocol
  if( req.http.X-Forwarded-Proto == "http" && req.url ~ "/(ecas|login|logout|register|user)" ) {
    return(synth(301, "https://"  + req.http.host + req.url ));
  }
  // Basic url sercure list :
  if (
    req.url ~ "(?i)\.(sql?|dump)\??.*$" ||
    req.url ~ "\/\.(git|svn|htpasswd|htaccess)" ||
    req.url ~ "\.(engine|inc|info|install|make|module|profile|test|po|sh|theme|tpl(\.php)?|xtmpl|svn-base)$"
    ) {
    return(synth(403,"Blacklisted"));
  }
}

sub vcl_synth {
    if (resp.status == 301 || resp.status == 302) {
        set resp.http.location = resp.reason;
        set resp.reason = "Moved";
        return (deliver);
    }
}
