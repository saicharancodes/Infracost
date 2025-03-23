import base64
import os
import subprocess
branch_name = "NFRCSTHH-1-create-a-bucket-in-gcp"

try:
    # Check if the branch exists, if not, create it.
    subprocess.run(["git", "checkout", branch_name], check=True, cwd=r"C:/Users/stu108/Downloads/Infracost")
    subprocess.run(["git", "add", "*"], check=True, cwd=r"C:/Users/stu108/Downloads/Infracost")
    subprocess.run(["git", "commit", "-m", "Add generated terraform code"], check=True, cwd=r"C:/Users/stu108/Downloads/Infracost")
    subprocess.run(["git", "push", "origin", branch_name], check=True, cwd=r"C:/Users/stu108/Downloads/Infracost")
    print(f"Terraform code committed and pushed to branch '{branch_name}'.")
except subprocess.CalledProcessError as e:
    print(f"Git operation failed: {e}")
except FileNotFoundError:
    print("Git is not installed or not in PATH.")