# openssl-cert-atlassian
check for ssl certificate 

Tested on atlassian products: Confluence, jira. 

Based on this article:
https://confluence.atlassian.com/kb/connecting-to-ssl-services-802171215.html#HowtoimportapublicSSLcertificateintoaJVM-commandline

I made it to make life easier for checking and creating certificates. I will be glad if anyone find it useful

USAGE:

The program needs for two args: 
  --domain=<> - domain wich you want to check
  --path=<> - path to certs store, confluence, jira, for example: <INSTL_DIR>/jre/lib/security/cacerts
