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
