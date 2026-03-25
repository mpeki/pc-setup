#!/usr/bin/env bash
# Discover a working internal DNS while on VPN and (optionally) apply split-DNS.
# Usage: ./find-internal-dns.sh [--apply]

set -u
APPLY=${1:-}

# 1) Find VPN iface: default route via a 10.x.x.x address
VPN_IF=$(ip -4 route | awk '/^default via 10\./{print $5; exit}')
if [[ -z "${VPN_IF:-}" ]]; then
  echo "No VPN default route via 10.0.0.0/8 found. Are you connected?" >&2
  exit 1
fi

# 2) Get VPN /24 base (a.b.c)
VPN_IP=$(ip -4 addr show "$VPN_IF" | awk '/inet /{print $2}' | head -n1 | cut -d/ -f1)
BASE=$(awk -F. '{print $1"."$2"."$3}' <<<"$VPN_IP")

echo "VPN interface: $VPN_IF  (IP: $VPN_IP)"
echo "Probing likely internal DNS servers..."

found=""

probe() {
  local ip="$1"
  local ans
  ans=$(dig +time=1 +tries=1 +short mq1.dev.profac.dk @"$ip" 2>/dev/null || true)
  if [[ -n "$ans" && "$ans" == 10.* ]]; then
    echo "  $ip -> $ans  (OK)"
    found="$ip"
    return 0
  else
    echo "  $ip -> no response / not internal"
    return 1
  fi
}

# 3) Try common hosts on the VPN /24
for last in 1 2 10 11 53 100 200; do
  probe "$BASE.$last" && break
done

# 4) If not found, try .1 of each 10/8 route we have
if [[ -z "$found" ]]; then
  while read -r net; do
    host=$(cut -d/ -f1 <<<"$net" | awk -F. '{print $1"."$2"."$3".1"}')
    probe "$host" && break
  done < <(ip -4 route | awk '/^10\./{print $1}')
fi

if [[ -z "$found" ]]; then
  echo "No internal DNS found by quick probes. Ask IT/colleague for the DNS IP." >&2
  exit 2
fi

echo
echo "Found internal DNS: $found"
echo "Test directly:  dig +short mq1.dev.profac.dk @$found"

# 5) Optionally apply split-DNS
if [[ "$APPLY" == "--apply" ]]; then
  echo
  echo "Applying split-DNS for ~dev.profac.dk and ~profac.dk on $VPN_IF ..."
  sudo resolvectl dns "$VPN_IF" "$found"
  sudo resolvectl domain "$VPN_IF" '~dev.profac.dk' '~profac.dk'
  sudo resolvectl flush-caches
  echo "Re-test:"
  resolvectl query mq1.dev.profac.dk
else
  echo
  echo "To use it for split-DNS this session, run:"
  echo "  sudo resolvectl dns $VPN_IF $found"
  echo "  sudo resolvectl domain $VPN_IF '~dev.profac.dk' '~profac.dk'"
  echo "  sudo resolvectl flush-caches && resolvectl query mq1.dev.profac.dk"
fi

