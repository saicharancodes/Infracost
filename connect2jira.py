import requests
from requests.auth import HTTPBasicAuth
import json

# Replace these with your Jira details
JIRA_URL = "https://jiraautomate.atlassian.net"  # Change to your Jira domain
API_TOKEN = "ATATT3xFfGF0Li7NP7bCaKbceh3eEHrxgLvMfXCEpS2i_DyrjoPmt3AOQkVuCp4rpEf6hpMZy6GfxjiqOAzh_QRka0XzuGy_SVI30g8tBLZ7ogGxgc40rScAvYBcmTFk9xkprBOmo8fzxXUVnoD9SMC4dvEtxNs46vB8JkiRz4cm35GZ90DaIpk=BCA65869"  # Paste your API token here
EMAIL = "post2saicharan@gmail.com"  # Your Atlassian email

# Jira API endpoint to access dashboard info
DASHBOARD_ID = 1  # Replace with your dashboard ID
url = f"{JIRA_URL}/rest/api/3/dashboard/{DASHBOARD_ID}"

# Authenticate using API token
auth = HTTPBasicAuth(EMAIL, API_TOKEN)

# Set headers for the request
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Send GET request to Jira API
response = requests.get(url, headers=headers, auth=auth)

# Check if the request was successful
if response.status_code == 200:
    dashboard_data = response.json()
    print(json.dumps(dashboard_data, indent=4))
else:
    print(f"Failed to connect. Status Code: {response.status_code}")
    print(response.text)
