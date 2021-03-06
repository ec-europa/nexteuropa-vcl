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
    // Basic url secure list :
    if (
        req.url ~ "(?i)\.(sql?|dump)\??.*$" ||
        req.url ~ "\/\.(git|svn|htpasswd|htaccess|phps)" ||
        req.url ~ "\.(engine|inc|info|install|make|module|profile|test|po|sh|theme|tpl(\.php)?|xtmpl|svn-base)$" ||
        req.url ~ "^sites/+[^/]+/+files(/+[^/]+)*/+private_files" ||
        req.url ~ "/update\.php(\?.*)?$" ||
        req.url ~ "/(a1|m|ng(ok)?1?)\.php(\?.*)?$"
    ) {
        return(synth(451, "Blacklisted"));
    }
}

sub vcl_synth {
    // Don't cache any synth replies
    set resp.http.Cache-Control = "private, maxage=0, s-maxage=0";
    if (resp.status == 301 || resp.status == 302) {
        set resp.http.location = resp.reason;
        set resp.reason = "Moved";
        return (deliver);
    }
}


# Called before the response is delivered to the client.
sub vcl_deliver {
  # rename X-Varnish to X-FPFIS
  set resp.http.X-FPFIS = resp.http.X-Varnish;
  unset resp.http.X-Varnish;
  unset resp.http.Via;

}
