vcl 4.0;

import std;
import drupal7;
import cookie;
import header;

backend default {
  .host = "127.0.0.1";
}

include "nexteuropa/nexteuropa.vcl";
