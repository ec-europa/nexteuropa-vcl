sub vcl_recv {
    # Varnish will set client.identity for you based on client IP.

    if ( req.http.X-FPFIS-Is-Bot == "yes" && vsthrottle.is_denied(req.http.user-agent, 5, 10s)) {
        # Client has exceeded 5 reqs per 10s
        return (synth(429, "Too Many Requests"));
    }

    # Only allow a few POST/PUTs per client for external traffic.
    if (req.http.Client-IP && (req.method == "POST" || req.method == "PUT")) {
        if (vsthrottle.is_denied("rw" + req.http.Client-IP, 10, 10s)) {
            return (synth(429, "Too Many Requests"));
        }
    }
}
