sub vcl_recv {
      unset req.http.Authorization;
    
      if (
           req.url ~ "^/+capacity4dev" 
            &&
           req.http.host ~ "^europa\.eu") { 
           
           set req.http.X-FPFIS-Application-Base-Path = "/capacity4dev";
           set req.http.X-FPFIS-Application-Path = regsub(req.url, "^/+capacity4dev", "");
           
           set req.http.X-FPFIS-Application-Name = "Unkown";
           
           set req.http.X-FPFIS-Application-Host = req.http.host;
      } 
    
       if ( req.http.X-Forwarded-Proto && req.http.X-Forwarded-Proto !~ "(?i)https") {
         return (synth(443, ""));
       }
}
 
sub vcl_synth {
  if (resp.status == 443) {
        set resp.status = 301;
        set resp.http.Location = "https://" + req.http.host + req.url;
        return(deliver);
  }
  if (resp.status == 401) {
    set resp.status = 401;
    set resp.http.WWW-Authenticate = "Basic";
    return(deliver);
  }
}
