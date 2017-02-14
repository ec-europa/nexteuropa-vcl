#FPFIS Docker image for varnish5

##Prepare

Nexteuropa is atually a submodule, other VCLs can come before or after,
that's why the whole code also needs to be in nexteuropa/ folder when
running locally, otherwise varnish will complain. 

To fix this :

```
ln -s . nexteuropa
```

##Download

```
docker pull fpfis/varnish5
```

##Use

You probably want to use port mapping here (or docker-compose) :

```
docker run -v $(pwd):/srv/vcl fpfis/varnish5
```
