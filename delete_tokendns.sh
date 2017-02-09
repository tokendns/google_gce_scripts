#!/bin/bash
# script: delete VM with TokenDNS when it gets terminated
# author: Steffen <hello@tokendns.co>
# notes: Use this script as your Shutdown script and configure "domain" and "apikey" as Metadata keys

# Call GCE Metadata Service
name=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/name -H "Metadata-Flavor: Google")
apikey=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/attributes/apikey -H "Metadata-Flavor: Google")
domain=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/attributes/domain -H "Metadata-Flavor: Google")

# Get IPv4 and IPv6 address
ipv4=$(curl -s -4 https://ip.tokendns.co)
ipv6=$(curl -s -6 https://ip.tokendns.co)

# Register A record
curl --get "https://api.tokendns.co/v1/delete" -d apikey=${apikey} -d name=${name} -d domain=${domain} -d type=A -d content=${ipv4}

# Register AAAA record (if IPv6 is available)
if [ -n "${ipv6}" ]; then
	curl --get "https://api.tokendns.co/v1/delete" -d apikey=${apikey} -d name=${name} -d domain=${domain} -d type=AAAA -d content=${ipv6}
fi



