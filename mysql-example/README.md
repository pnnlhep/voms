# Sample mysql deployment for VOMS back end

DE Cowley 1/9/2019:

This directory contains a selection of sample templates that show a way to
provide a mysql back end database with a generic mysql image.  It relies on a
persistent storage volume allocated via a K8s physical volume claim (PVC) and a
physical volume (PV).

Files:
  * mysql-voms-pv.yaml      defines the physical volume for persistent storage
  * mysql-voms-pvc.yaml     defines the physical volume claim
  * mysql-voms-deployment.yaml  defines the deployment with appropriate PV and secrets

Create the resources from these templates before attempting to bring up the client VOMS front end.
