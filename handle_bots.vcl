sub vcl_recv {
    if (req.http.User-Agent ~ "(?i)(outeubot)") {
        set req.http.X-is-bot = "yes";
        return (
          synth(503, "Disallowed")
        );
    }
    if (req.http.User-Agent ~ "(?i)(vspider|Scrapy/)") {
        set req.http.X-is-bot = "yes";
        return (
          synth(503, "Disallowed")
        );
    }
    else if (req.http.User-Agent ~ "(?i)((Google|bing|Yandex|Seznam|Showyou|Livelap|Twitter|msn|eu)bot|Baiduspider|spider|Yahoo! Slurp|FAST Enterprise Crawler . used by|Web Link Validator|Scrapy/)") {
        set req.http.X-is-bot = "yes";
        if (req.url ~ "/+[a-z]{2}/+(print/+)?search/") {
            return (
              synth(403, "Disallowed by robots.txt")
            );
        }
    }
}
