# VOMS server deployment in K8S

DE Cowley 8/16/18:

This collection of stuff implements a VOMS service (currently) supporting a single Virtual Organization.  It assumes a working MySQL database with valid VOMS data in it is available at `voms-backend` on port 3306.  

Documentation for this version of VOMS is available at https://italiangrid.github.io/voms/documentation.html.  The `voms-configure` command will be of interest to create and administer VOs.

A way to create a database for a new VO is to create a new MySQL backend container with persistent storage, then add and import an existing dump in the container.  The alternative is to make a new empty database and issue voms-configure commands from a VOMS server container manually.

The `voms-configure` script that is in the configmap is careful to set up the VOMS server config while *not* disturbing the existing data in the MySQL database.  This theoretically allows redeployment and maybe multiple front-end instances, but that has *not* been tested.

The mysql root password and other needed things like certificates are provided in the voms-secrets.yaml file.  Certificates can be serialized for inclusion in the secrets file like:
```cat hostcert.pem | base64```

Example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: voms-secrets
  namespace: voms
type: Opaque
data:
voms-hostkey: <serialized X509 host key >
voms-hostcert: <serialized X509 host certificate>
mysql-root-password: <serialized password string>

```


To bring this up, do something like:

Ensure the Docker image at pnnlhep/voms-server-front:latest is available and up to date.  The Dockerfile here can be used to build it, pushing that image is up to you.

- Create the VOMS database back end (examples are probably somewhere nearly in the mysql-project8-*.yaml files)
```
$ kubectl create -f ./voms-back-service.yaml
$ kubectl create -f ./voms-secrets.yaml
$ kubectl create -f ./voms-configmap.yaml
$ kubectl create -f ./voms-deployment.yaml
$ kubectl create -f ./voms-front-service.yaml
```


NOTES:  
  * For some reason in the finished front end container, I've had to edit the file `/etc/voms/<vo>/voms.conf` to fix up the `--uri=voms.hep.pnnl.gov:<port>` entry to have the complete FQDN.  This was hacked around in `start.sh` from `voms-configmap.yaml` file.
  * Use of the `--skip-voms-admin` flag on `voms-configure` on deployment has been used to "hide" (and unhide) a VO (e.g. ccsdi) without getting rid of it.

