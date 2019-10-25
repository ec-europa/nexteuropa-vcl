sub vcl_recv {
    set req.http.X-Application-Tag = "Awesome-Drupal";
    set req.http.X-FPFIS-Application-Name = "Unkown";
    set req.http.X-FPFIS-Application-Host = req.http.host;
    if (
        req.url ~ "^/+subsite" &&
        req.http.host ~ "^europa\.eu"
    ) { 
        unset req.http.Authorization;
        set req.http.X-FPFIS-Application-Base-Path = "/subsite";
        set req.http.X-FPFIS-Application-Path = regsub(req.url, "^/+subsite", "");
    }else{
        set req.http.X-FPFIS-Application-Base-Path = "/";
        set req.http.X-FPFIS-Application-Path = regsub(req.url, "^(\/)/*(.*)$", "\2");
    } 
    if ( req.http.X-Forwarded-Proto && req.http.X-Forwarded-Proto !~ "(?i)https") {
        return (synth(443, ""));
    }
}
