### RED WARNING : for testing only, do not merge until secret can be fetched from env

sub vcl_recv {
          std.log("Purge received");

    # invalidate:dydneecirnitnoikOowmucnaygAwjalp (testing cluster)
    if (req.method ~ "(PURGE|BAN)") {
        # A X-Invalidate-Type header means we are dealing with a "Flexible
        # Purge" request, which is more powerful but also more dangerous
        # than usual purge requests.
        # Therefore, require a basic authentication.
        if( req.http.Authorization == "Basic aW52YWxpZGF0ZTpkeWRuZWVjaXJuaXRub2lrT293bXVjbmF5Z0F3amFscA==" ) {
          std.log("Purge accepted");
          call handle_purge_requests;
        } else {
        return (
                                  synth(403, "FORBIDDEN")
                                );
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
    ban("req.http.host == " + req.http.host + " && req.http.url == " + req.url);

    # The provided URL usually has no trailing slash; also invalidate variants having one.
    if (req.url !~ "/+$") {
        ban("req.http.host == " + req.http.host + " && req.http.url == " + req.url + "/");
    }

    return (
                  synth(200, "PURGED")
                );
}

# Handle PURGE requests emitted by the "Flexible Purge" Drupal module.
sub handle_flexible_purge_requests {
    call check_invalidate_headers;
          std.log("Purge accepted flexible");

    if (req.http.X-Invalidate-Type == "full") {
        if (req.http.X-Invalidate-Tag) {
            ban("obj.http.X-Application-Tag == " + req.http.X-Invalidate-Tag);
                return (
                              synth(200, "PURGED")
                            );
        }
        elseif (req.http.X-Invalidate-Host && req.http.X-Invalidate-Base-Path) {
            ban("obj.http.X-Host == " + req.http.X-Invalidate-Host + " && obj.http.X-Url ~ ^" + req.http.X-Invalidate-Base-Path);
                return (
                              synth(200, "PURGED")
                            );
        }
    }
    elseif (req.http.X-Invalidate-Type ~ "^(wildcard|regexp-(multiple|single))$") {
        if (req.http.X-Invalidate-Regexp) {
            if (req.http.X-Invalidate-Tag) {
                ban("obj.http.X-Application-Tag == " + req.http.X-Invalidate-Tag + " && obj.http.X-FPFIS-Drupal-Path ~ " + req.http.X-Invalidate-Regexp);
                    return (
                                  synth(200, "PURGED")
                                );
            }
            else if (req.http.X-Invalidate-Host) {
                ban("obj.http.X-Host == " + req.http.X-Invalidate-Host + " && obj.http.X-FPFIS-Drupal-Path ~ " + req.http.X-Invalidate-Regexp);
                    return (
                                  synth(200, "PURGED")
                                );
            }
        }
    }
        return (
                      synth(400, "ERROR")
                    );
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
            return (
                          synth(405, "FORBIDDEN")
                        );
    }
    if (req.http.X-Invalidate-Host ~ " && ") {
            return (
                          synth(406, "FORBIDDEN")
                        );
    }
    if (req.http.X-Invalidate-Base-Path ~ " && ") {
            return (
                          synth(407, "FORBIDDEN")
                        );
    }
    if (req.http.X-Invalidate-Regexp ~ " && ") {
            return (
                          synth(408, "FORBIDDEN")
                        );
    }
}
