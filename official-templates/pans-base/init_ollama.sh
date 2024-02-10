#!bin/bash
# This script is used to install the necessary packages for the Ollama container
# It also installs the Ollama package and the Gradio client package
# It also installs the lsof package which is used to check if the port is in use
# It also downloads the check_and_kill.sh and run_ollama.sh scripts to the workspace directory
# The check_and_kill.sh script is used to check if the port is in use and kill the process if it is
# The run_ollama.sh script is used to run the Ollama container
curl -fsSL https://ollama.com/install.sh | sh &&
python3.10 -m pip install litellm litellm[proxy] &&
pip install gradio_client==0.2.7 &&
apt-get update &&
apt-get install -y lsof &&
curl -o /workspace/check_and_kill.sh https://raw.githubusercontent.com/ozenhaluk/containers/main/official-templates/pans-base/check_and_kill.sh && 
curl -o /workspace/run_ollama.sh https://raw.githubusercontent.com/ozenhaluk/containers/main/official-templates/pans-base/run_ollama.sh &&
cp /workspace/check_and_kill.sh /check_and_kill.sh &&
cp /workspace/run_ollama.sh /run_ollama.sh