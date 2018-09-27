sub vcl_recv {
    unset req.http.Authorization;
    if (
       req.url ~ "^/+subsite" &&
       req.http.host ~ "^europa\.eu"
    ) { 
       set req.http.X-FPFIS-Application-Base-Path = "/subsite";
       set req.http.X-FPFIS-Application-Path = regsub(req.url, "^/+subsite", "");
       set req.http.X-FPFIS-Application-Name = "Unkown";
       set req.http.X-FPFIS-Application-Host = req.http.host;
    } 
    if ( req.http.X-Forwarded-Proto && req.http.X-Forwarded-Proto !~ "(?i)https") {
        return (synth(443, ""));
    }
}
