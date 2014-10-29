docker-confd
============

Base image with confd and supervisor. Use to make a service dynamically configured using confd. This image starts from ubuntu:latest and installs both confd and supervisor so that services can easily inherit dynamic configuration using confd from any backend that confd supports. It also provides a start script */opt/start* that will initialize confd and start the supervisor after adding a */etc/supervisor/conf.d/confd.conf* so that configuration can be dynamically changed.

In order to use this base image, your Dockerfile should specify *FROM cjhardekopf/confd*. After installing and setting up the desired service you need to put the appropriate dynamic configuration in */etc/confd/conf.d/* and */etc/confd/templates/*. This will set up the runtime configuration. In addition, put at least one *<service>.conf* file in */etc/supervisor/conf.d/* so that supervisor can correctly start your service. In the confd configuration make sure to tell it how to restart your service (using supervisor) on configuration changes if necessary. Then you should just use the */opt/start* script as your *ENTRYPOINT* to start everything.

You can specify a subset of the confd command line arguments as arguments to the */opt/start* script in order to configure the source of configuration information:
* -b|--backend=\"$backend\"
* --client-ca-keys=\"$client_ca_keys\"
* --client-cert=\"$client_cert\" 
* --client-key=\"$client_key\" 
* -i|--interval=$interval
* -n|--node=[$node]
* -p|--prefix=\"$prefix\"
* -s|--scheme=\"$scheme\"
* --srv-domain=\"$srv_domain\"
* -w|--watch
* -h|--help

You can also specify some of the basic options from the environment. They are all optional and can be overridden from the command line:
* ETCD_BACKEND
* ETCD_INTERVAL
* ETCD_NODE
* ETCD_PREFIX
* ETCD_SCHEME
