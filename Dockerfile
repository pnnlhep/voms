FROM centos:centos6.8
MAINTAINER David Cowley "david.cowley@pnl.gov"

RUN ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN rpm --import http://repository.egi.eu/sw/production/umd/UMD-RPM-PGP-KEY

RUN curl -L -O http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y epel-release-6-8.noarch.rpm
RUN yum install -y yum-priorities
RUN yum install -y http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.2-1.el6.noarch.rpm
RUN yum update -y
RUN yum install -y emi-voms-mysql \
  ca-policy-egi-core \
  postfix \
  mailx


# This would be better done in a K8s container:
#RUN /usr/sbin/fetch-crl

# FIXME: still need a good solution for CILogon OpenID CA certs. I have a
# tarfile I could stick in here, but really want an RPM.

ADD do-nothing.sh /etc/do-nothing.sh
ADD cilogon-openid-certs.tar /etc/grid-security/certificates
#RUN tar xvfC /tmp/cilogon-openid-certs.tar /etc/grid-security/certificates


# Expose ports for main service and up to 3 VOs:
EXPOSE 8443
EXPOSE 15010
EXPOSE 15020
EXPOSE 15030

# FIXME: this container won't run without /etc/start.sh.  But that's application
# specific.  Stick in a generic (useless) stub:
#CMD /etc/start.sh
CMD /etc/do-nothing.sh
