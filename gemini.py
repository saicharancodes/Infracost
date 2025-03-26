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
                types.Part.from_text(text="""  create a vm and bucket in gcp 
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

    import subprocess
    import os

    # Change to the directory containing your script if needed
    script_dir = r"C:/Users/stu108/Downloads/Infracost"
    os.chdir(script_dir)

    # Execute the script
    subprocess.run(["wsl", "sh", "./auto.sh"], check=True)

if __name__ == "__main__":
    generate()
 
