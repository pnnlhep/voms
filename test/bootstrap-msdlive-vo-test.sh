voms-mysql-util \
  create_db \
  --dbhost=$VOMS_BACKEND_SERVICE_HOST \
  --dbport=3306 \
  --dbauser root \
  --dbapwd=$MYSQL_ROOT_PASSWORD \
  --vomshost voms-test.hep.pnnl.gov \
  --dbname voms_msdlive \
  --dbusername root \
  --dbpassword=$MYSQL_ROOT_PASSWORD

voms-configure install \
  --vo=msdlive \
  --deploy-database \
  --dbtype=mysql \
  --dbname=voms_msdlive \
  --dbusername=root \
  --dbapwd=$MYSQL_ROOT_PASSWORD \
  --createdb \
  --dbhost=$VOMS_BACKEND_SERVICE_HOST \
  --dbport=3306 \
  --dbauser=root \
  --dbpassword=$MYSQL_ROOT_PASSWORD \
  --core-port=15030 \
  --smtp-host=emailgw02.pnnl.gov \
  --mail-from='david.cowley@pnnl.gov'

voms-db-util add-admin --vo=msdlive \
  --dn="/DC=org/DC=cilogon/C=US/O=Google/CN=David Cowley A252526" \
  --email=david.cowley@pnnl.gov \
  --ca="/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OpenID CA 1"
