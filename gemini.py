import base64
import os
from google import genai
from google.genai import types

def generate():
    client = genai.Client(
        api_key="AIzaSyAywz4tcNXJBVKDlt8wMUeKsU-_D57FWks",  # Replace with your actual API key
    )

    model = "gemini-2.0-flash"
    contents = [
        types.Content(
            role="user",
            parts=[
                types.Part.from_text(text="""[POPS-1] Bucket Create -network-tkoff-<env> - out-dlm-is-<env> 

Status:	Closed
Project:	Plas

Component/s:	None 
Affects Version/s:	None 
Fix Version/s:	None 

Type: 	Task 	Priority: 	Major 
Reporter: 	sa	Assignee: 
Resolution: 	Done 	Votes: 	0 
Labels: 	SNS, dta_cer, network, network-tkoff 
Remaining Estimate:	Not Specified 
Time Spent:	Not Specified 
Original Estimate:	Not Specified 


 Description  	 
Read before creating your first ticket:
Task/Incident description: 
Please create bucket   out-dlm-is-<env> with the following details:-
Project: network-tkoff-<env>
Environments Affected: all
SM and Squad who need the ticket:  Har
Item	Value
Name	out-dlm-is-<env>
Location	europe-west1
Storage Class	STANDARD
Life Cycle Rules	nearline_7_coldline_30_delete_90
Labels:	 
data-classification	is
pii_included	no
crop_number	NA
bucket_type	data
data_container_name	Specify the container name where the data is stored - <>
Read/Write Access	tf-<env>.iam.gserviceaccount.com
ftp-<enviam.gserviceaccount.com
Read Only Access	<please specify which service account should have Read Only access, please highlight if it's another project Service Account>
Impact: will not be able to create the extracts for Openreach reports.
Blocker: yes
Expected go live date: December

"""),
            ],
        ),
    ]
    generate_content_config = types.GenerateContentConfig(
        temperature=1,
        top_p=0.95,
        top_k=40,
        max_output_tokens=8192,
        response_mime_type="text/plain",
        system_instruction=[
            types.Part.from_text(text="""you just generate terraform code for gcp with no explantion of code.you just generate code."""),
        ],
    )

    # Open a file to write the output
    with open(r"C:/Users/stu108/Downloads/Infracost/main.tf", "w") as f:
        response_text = ""
        for chunk in client.models.generate_content_stream(
            model=model,
            contents=contents,
            config=generate_content_config,
        ):
            # Append chunk text to response_text
            response_text += chunk.text
            # Optionally, still print to console to see progress
            print(chunk.text, end="", flush=True)
        
        # Trim first and last lines
        trimmed_text = '\n'.join(response_text.strip().split('\n')[1:-1])
        
        # Write the trimmed response to the file
        f.write(trimmed_text)
    
    print("\n\nGenerated Terraform code has been saved to main.tf")

if __name__ == "__main__":
    generate()