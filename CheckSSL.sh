#/bin/sh

## Usage information when no args added
if  [[ "$#" -eq "0"  ]]; then

	echo -e "Usage of this script: \n"
	echo -e "--domain=<domain.name>; \n\t\t Domain name of the service \n"
	echo -e "--path=<path>; \n\t\t Path to <SERVICE_DIR>/jre/lib/security/cacerts \n"
	exit 0
fi

echo -e "\n\n\n"
## Parse args
for key in $@; do
case $key in
	
	--domain=*)
		domain=${key#--domain=}
;;
	--path=*)
		path=${key#--path=}
;;
	*)
	echo "There is no such arg key"
	exit 0
;;
esac
done

cd /tmp/

## If the file not exists
if [[ ! -f SSLPoke.class ]]; then

	wget --no-check-certificate https://confluence.atlassian.com/kb/files/779355358/779355357/1/1441897666313/SSLPoke.class
fi

## Check SSL connection
check="$(java -Djavax.net.ssl.trustStore="$path" SSLPoke $domain 443 2>/dev/null)"

## If connected successfully get out
if [[ $check  == *"Successfully connected"* ]]; then

	echo "Everything is fine"
	exit 0
fi

## If not you need to create 
echo "Certificate check failed"
echo "Do you want to create one?" 
read result

case $result in 

yes)
	yum install java -y || apt install java -y
	openssl s_client -connect $domain:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > public.crt 
	echo "Type the password: changeit"
	keytool -import -alias $domain -keystore $path -file public.crt
	
	check="$(java -Djavax.net.ssl.trustStore="$path" SSLPoke $domain 443)"
	if [[ $check != *"Successfully connected"*   ]]; then
		echo "Something goes wrong. Check path and domain name"
		exit 1
	fi
	echo "Certificate created."
;;
no)
	exit 0
;;
esac
