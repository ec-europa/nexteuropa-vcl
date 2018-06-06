### RED WARNING : for testing only, do not merge until secret can be fetched from env

sub vcl_recv {
    # invalidate:dydneecirnitnoikOowmucnaygAwjalp (testing cluster)
    if (req.request ~ "(PURGE|BAN)") &&
        req.http.X-Invalidate-Type &&
        req.http.Authorization == "Basic aW52YWxpZGF0ZTpkeWRuZWVjaXJuaXRub2lrT293bXVjbmF5Z0F3amFscA==") {
        # A X-Invalidate-Type header means we are dealing with a "Flexible
        # Purge" request, which is more powerful but also more dangerous
        # than usual purge requests.
        # Therefore, require a basic authentication.
        std.log("Purge received")
        call handle_purge_requests;
    }
}


sub handle_purge_requests {
    if (req.request == "PURGE") {
        # purge does not fit our needs because it only evicts Vary-based
        # variants of an object while we want to get rid of every object
        # matching the given URL and Host.
        if (req.http.X-Invalidate-Type) {
            call handle_flexible_purge_requests;
        }
        else {
            call handle_simple_purge_requests;
        }
    }
    else if (req.request == "BAN") {
        call handle_blogs_purge_requests;
    }
}


sub handle_simple_purge_requests {
    # Ban the provided URL as is.
    ban("obj.http.x-host == " + req.http.host + " && obj.http.x-url == " + req.url);

    # The provided URL usually has no trailing slash; also invalidate variants having one.
    if (req.url !~ "/+$") {
        ban("obj.http.x-host == " + req.http.host + " && obj.http.x-url == " + req.url + "/");
    }

    error 200 "OK";
}

# Handle PURGE requests emitted by the "Flexible Purge" Drupal module.
sub handle_flexible_purge_requests {
    call check_invalidate_headers;
    if (req.http.X-Invalidate-Type == "full") {
        if (req.http.X-Invalidate-Tag) {
            ban("obj.http.X-Application-Tag == " + req.http.X-Invalidate-Tag);
            error 200 "OK";
        }
        elseif (req.http.X-Invalidate-Host && req.http.X-Invalidate-Base-Path) {
            ban("obj.http.X-Host == " + req.http.X-Invalidate-Host + " && obj.http.X-Url ~ ^" + req.http.X-Invalidate-Base-Path);
            error 200 "OK";
        }
    }
    elseif (req.http.X-Invalidate-Type ~ "^(wildcard|regexp-(multiple|single))$") {
        if (req.http.X-Invalidate-Regexp) {
            if (req.http.X-Invalidate-Tag) {
                ban("obj.http.X-Application-Tag == " + req.http.X-Invalidate-Tag + " && obj.http.X-FPFIS-Drupal-Path ~ " + req.http.X-Invalidate-Regexp);
                error 200 "OK";
            }
            else if (req.http.X-Invalidate-Host) {
                ban("obj.http.X-Host == " + req.http.X-Invalidate-Host + " && obj.http.X-FPFIS-Drupal-Path ~ " + req.http.X-Invalidate-Regexp);
                error 200 "OK";
            }
        }
    }
    error 400 "Bad request";
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
    if (req.http.X-Invalidate-Tag ~ " && ") {
        error 400 "Bad request";
    }
    if (req.http.X-Invalidate-Host ~ " && ") {
        error 400 "Bad request";
    }
    if (req.http.X-Invalidate-Base-Path ~ " && ") {
        error 400 "Bad request";
    }
    if (req.http.X-Invalidate-Regexp ~ " && ") {
        error 400 "Bad request";
    }
}
