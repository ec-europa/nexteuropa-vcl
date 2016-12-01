sub vcl_backend_response {
  std.log("backend_used:" + beresp.backend.name);
}
include "nexteuropa/init_headers.vcl";
include "nexteuropa/handle_bots.vcl";
include "nexteuropa/clean_cookie.vcl";
include "nexteuropa/cache_policy.vcl";
