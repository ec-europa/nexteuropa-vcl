# Basic salt config and helpers from 
# https://github.com/ec-europa/salt-reference/blob/master/upsalter/varnish/vcl

sub vcl_synth {
    set resp.http.Cache-Control = "private, maxage=0, s-maxage=0";
    if (resp.status == 301 || resp.status == 302) {
        set resp.http.location = resp.reason;
        set resp.reason = "Moved";
        return (deliver);
    }
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
