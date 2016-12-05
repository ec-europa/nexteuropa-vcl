sub vcl_recv {
    # Varnish will set client.identity for you based on client IP.

    if (vsthrottle.is_denied(client.identity, 15, 10s)) {
        # Client has exceeded 15 reqs per 10s
        return (synth(429, "Too Many Requests"));
    }

    # There is a quota per API key that must be fulfilled.
    if (vsthrottle.is_denied("apikey:" + req.http.Key, 30, 60s)) {
            return (synth(429, "Too Many Requests"));
    }

    # Only allow a few POST/PUTs per client.
    if (req.method == "POST" || req.method == "PUT") {
        if (vsthrottle.is_denied("rw" + client.identity, 2, 10s)) {
            return (synth(429, "Too Many Requests"));
        }
    }
}
