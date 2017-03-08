sub vcl_recv {
    if (
    req.http.User-Agent ~ "(?i)((outeubot|vspider|Google|bing|Yandex|Seznam|Showyou|Livelap|Twitter|msn|eu)bot|Baiduspider|spider|Yahoo! Slurp|FAST Enterprise Crawler . used by|Web Link Validator|europasearch|Scrapy/)"
    ||
    req.http.Client-IP ~ "(75\.151\.23)") {
        set req.http.X-FPFIS-Is-Bot = "yes";
        if (req.url ~ "/+[a-z]{2}/+(print/+)?search/") {
            return (
              synth(403, "Disallowed by robots.txt")
            );
        }
    }
}
