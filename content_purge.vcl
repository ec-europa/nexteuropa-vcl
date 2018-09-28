sub vcl_recv {
    # invalidate:test (testing cluster)
    if (req.method ~ "(PURGE|BAN)") {
        std.log("Purge received");
        # A X-Invalidate-Type header means we are dealing with a "Flexible
        # Purge" request, which is more powerful but also more dangerous
        # than usual purge requests.
        # Therefore, require a basic authentication.
        if( req.http.Authorization == "Basic " + std.getenv("VARNISH_PURGE_KEY")) {
          std.log("Purge accepted");
          call handle_purge_requests;
        } else {
          return (synth(403, "FORBIDDEN"));
        }
    }
}

sub handle_purge_requests {
    if (req.method == "PURGE") {
        # purge does not fit our needs because it only evicts Vary-based
        # variants of an object while we want to get rid of every object
        # matching the given URL and Host.
        if (req.http.X-Invalidate-Type) {
            std.log("Purge accepted type");
            call handle_flexible_purge_requests;
        }
        else {
            call handle_simple_purge_requests;
        }
    }
}

sub handle_simple_purge_requests {
    # Ban the provided URL as is.
    ban("req.http.host == " + req.http.host + " && req.url == " + req.url);
    # The provided URL usually has no trailing slash; also invalidate variants having one.
    if (req.url !~ "/+$") {
        ban("req.http.host == " + req.http.host + " && req.url == " + req.url + "/");
    }
    std.log(req.http.host + req.url + "PURGED");
        return (synth(200, "PURGED"));
}

# Handle PURGE requests emitted by the "Flexible Purge" Drupal module.
sub handle_flexible_purge_requests {
    call check_invalidate_headers;
    std.log("Purge accepted flexible");
    if (req.http.X-Invalidate-Type == "full") {
        if (req.http.X-Invalidate-Tag) {
            std.log("Tag based purge");
            ban("req.http.X-Application-Tag == " + req.http.X-Invalidate-Tag);
            std.log(req.http.X-Invalidate-Tag + "PURGED");
                return (synth(200, "PURGED"));
        }
        elseif (req.http.X-Invalidate-Host && req.http.X-Invalidate-Base-Path) {
            std.log(req.http.X-Invalidate-Host + req.http.X-Invalidate-Base-Path + "PURGED");
            ban("req.http.host == " + req.http.X-Invalidate-Host + " && req.url ~ ^" + req.http.X-Invalidate-Base-Path);
                return (synth(200, "PURGED"));
        }
    }
    elseif (req.http.X-Invalidate-Type ~ "^(wildcard|regexp-(multiple|single))$") {
        if (req.http.X-Invalidate-Regexp) {
            if (req.http.X-Invalidate-Tag) {
                std.log("X-Invalidate-Tag regex based purge");
                ban("req.http.X-Application-Tag == " + req.http.X-Invalidate-Tag + " && req.http.X-FPFIS-Drupal-Path ~ " + req.http.X-Invalidate-Regexp);
                std.log(req.http.X-Invalidate-Tag + req.http.X-Invalidate-Regexp + "PURGED");
                    return (synth(200, "PURGED"));
            }
            else if (req.http.X-Invalidate-Host) {
                std.log("X-Invalidate-xxx regex based purge");
                ban("req.http.host == " + req.http.X-Invalidate-Host + " && req.url ~ " + req.http.X-Invalidate-Regexp);
                std.log(req.http.X-Invalidate-Host + req.http.X-Invalidate-Regexp + "PURGED");
                    return (synth(200, "PURGED"));
            }
        }
    }
    else {
        std.log("ERROR, bad type:" + req.http.X-Invalidate-Type);
        return (synth(400, "ERROR"));
    }
}

# Sanitize known headers with the intent of using them to compose ban
# statements.
# Ban statements generated from VCL code do not need to have their arguments
# surrounded with double quotes (this makes sense only when working with CLI
# tools such as varnishadm).
# Still, we must prevent ban injections by refusing to include HTTP headers
# containing " && " into the ban statement as they are very likely to be an
# injection attempt.
sub check_invalidate_headers {
    if (
        req.http.X-Invalidate-Tag ~ " && " ||
        req.http.X-Invalidate-Host ~ " && " ||
        req.http.X-Invalidate-Base-Path ~ " && " ||
        req.http.X-Invalidate-Regexp ~ " && "
    ) {
        std.log("X-Invalidate-* FORBIDDEN. DEBUG: Tag: " + req.http.X-Invalidate-Tag + "# Host: " + req.http.X-Invalidate-Host + " # Base-Path: " + req.http.X-Invalidate-Base-Path + " # Regexp :" + req.http.X-Invalidate-Regexp);
        return (synth(405, "FORBIDDEN"));
    }
}
