# Infracost

1) run the puthon script that contains gemini api that will genearte the terraform code and saves that code in main.tf

2) Infracost setup (https://www.infracost.io/docs/)

infracost configure set api_key MY_KEY ( you can find it here https://dashboard.infracost.io/org/post2saicharan/settings/api-tokens )

or you can give commnad  - infracost auth login , It will redirect to the webpage.

*************************************************************************************************************
install the infracost files

here - curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh (linux)

************************************************************************************************************


run the command for the cost breakdown (you should give the path where .tf file is located)


infracost breakdown --path .   

tb continued...........................
