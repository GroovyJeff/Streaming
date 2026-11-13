#!/bin/tcsh
# Usage: ./check_kalshi.sh <api_key_id> <private_key_path>

if ( $#argv < 2 ) then
    echo "Usage: $0 <api_key_id> <private_key_path>"
    exit 1
endif

set API_KEY_ID = "$argv[1]"
set PRIVATE_KEY_PATH = "$argv[2]"

set BASE_URL = "https://external-api.kalshi.com" # production
set API_PATH = "/trade-api/v2/portfolio/balance"
set METHOD = "GET"

# --- timestamp in milliseconds ---
set TIMESTAMP = `date +%s000`

# --- message to sign: timestamp + METHOD + path (no query string, no body) ---
set MESSAGE = "${TIMESTAMP}${METHOD}${API_PATH}"

# --- RSA-PSS SHA-256 signature, base64-encoded, no line wrapping ---
set SIGNATURE = `echo -n "$MESSAGE" | \
 openssl dgst -sha256 -sign "$PRIVATE_KEY_PATH" \
 -sigopt rsa_padding_mode:pss \
 -sigopt rsa_pss_saltlen:32 \
 -sigopt rsa_mgf1_md:sha256 | \
 base64 | tr -d '\n'`

if ( $status != 0 || "$SIGNATURE" == "" ) then
 echo "Error: failed to generate signature. Check your private key file."
 exit 1
endif

# --- test authentication by fetching account balance ---
echo "Checking Kalshi authentication..."
curl -s -X GET "${BASE_URL}${API_PATH}" \
 -H "KALSHI-ACCESS-KEY: ${API_KEY_ID}" \
 -H "KALSHI-ACCESS-TIMESTAMP: ${TIMESTAMP}" \
 -H "KALSHI-ACCESS-SIGNATURE: ${SIGNATURE}" \
 -H "Content-Type: application/json"
echo ""
