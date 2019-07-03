FROM fpfis/varnish:4.1
ADD . /etc/varnish/nexteuropa
RUN echo -n "\ninclude \"nexteuropa/default.vcl\";\n"  >> /etc/varnish/default.vcl