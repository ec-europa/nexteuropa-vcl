sub vcl_recv {
  call compute_drupal_session_cookie_name;
  if (req.http.Accept-Encoding) {
    if ( req.url ~ "(?i)\.(bz2|gif|otf|pdf|png|rar|svg|swf|tbz|tgz|ttf|woff2?|zip)(\?(itok=)?[a-z0-9_=\.\-]+)?$") {
            # No point in compressing these
            unset req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } elsif (req.http.Accept-Encoding ~ "deflate" && req.http.user-agent !~ "MSIE") {
            set req.http.Accept-Encoding = "deflate";
        } else {
            # unkown algorithm
            unset req.http.Accept-Encoding;
        }
    }
}

sub compute_drupal_session_cookie_name {
    # Ensure that, if successful, the computation is made only once per request.
    if (!req.http.X-FPFIS-Drupal-Session || req.http.X-FPFIS-Drupal-Session ~ "^$") {
        # Ensure we have the two values required for the computation
        if (!req.http.Host || !req.http.X-FPFIS-Drupal-Base-Path) {
            # We do not have the required values, set a non-NULL empty string as result.
            set req.http.X-FPFIS-Drupal-Session = "";
        }
        else {
            # Clean X-FPFIS-Drupal-Base-Path: no double /
            set req.http.X-FPFIS-Drupal-Base-Path-Cleaned = regsuball(req.http.X-FPFIS-Drupal-Base-Path, "/+", "/");
            # Drupal expects an empty string as $base_path instead of "/":
            if (req.http.X-FPFIS-Drupal-Base-Path-Cleaned ~ "^/+$") {
                set req.http.X-FPFIS-Drupal-Base-Path-Cleaned = "";
            }

            # The computation itself is made by vmod_drupal7.
            set req.http.X-FPFIS-Drupal-Session = drupal7.session_name(
                req.http.host,
                req.http.X-FPFIS-Drupal-Base-Path-Cleaned
            );
            if (!req.http.X-FPFIS-Drupal-Session) {
                # session_name returned NULL: something went wrong, set a
                # non-NULL empty string as result.
                set req.http.X-FPFIS-Drupal-Session = "";
            }
            else {
                # Secure cookies have an extra leading 'S'.
                if (req.http.X-Proto == "https") {
                    set req.http.X-FPFIS-Drupal-Session = "S" + req.http.X-FPFIS-Drupal-Session;
                }
            }
            unset req.http.X-FPFIS-Drupal-Base-Path-Cleaned;
        }
    }
}

