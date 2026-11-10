#!/bin/bash

#SAlut sunt student A

verify_ip() {
    local host="$1"
    local ip="$2"
    local dns_server="$3"
    local dns_ip=""

    while read -r label val; do
        if [[ "$label" == "Address:" ]]; then
            dns_ip="$val"
        fi
    done < <(nslookup "$host" "$dns_server" 2>/dev/null)

    if [[ -n "$dns_ip" && "$ip" != *"$dns_ip"* ]]; then
        echo "Bogus IP for $host in /etc/hosts! (Expected: $dns_ip, Found: $ip via DNS $dns_server)"
    fi
}

DNS_SERVER="8.8.8.8"

cat /etc/hosts | while read -r ip host rest; do
    [[ -z "$ip" || "$ip" == \#* ]] && continue

    verify_ip "$host" "$ip" "$DNS_SERVER"
done

