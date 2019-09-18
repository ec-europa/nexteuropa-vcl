ARG varnish_version=4.1
FROM fpfis/varnish:$varnish_version
ADD . /etc/varnish/nexteuropa
RUN echo -n "\ninclude \"nexteuropa/default.vcl\";\n"  >> /etc/varnish/default.vcl