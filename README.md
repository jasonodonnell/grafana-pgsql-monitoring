# Virtual Environment

This is the virtualization blueprint to deploy:
* PostgreSQL
* pgBackrest 
* Prometheus
* Grafana 

## Requirements

* Vagrant (tested on 1.8.6)
* Virtual Box (tested on 5.1.6)
* `vagrant-hostmanager`

To install `vagrant-hostmanager` run the following:

```bash
$ vagrant plugin install vagrant-hostmanager
```

## Deploy

```bash
$ vagrant up
```

## Access Prometheus 

First, create an SSH tunnel to prometheus:

```bash
$ ssh -i .vagrant/machines/prometheus/virtualbox/private_key \
      -N -f -L 9090:localhost:9090 vagrant@172.17.8.102
```

Next, create an SSH tunnel to grafana:

```bash
$ ssh -i .vagrant/machines/grafana/virtualbox/private_key \
      -N -f -L 3000:localhost:3000 vagrant@172.17.8.103
```

Next, navigate to the following:

```bash
http://localhost:9090/
http://localhost:3000/
```

## Setup Prometheus Datasource

After logging into Grafana, a datasource will need to be configured.  [Follow these 
instructions to setup the datasource.](https://github.com/jasonodonnell/grafana-pgsql-monitoring)
