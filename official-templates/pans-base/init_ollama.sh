curl https://ollama.ai/install.sh | sh &&
python3.10 -m pip install litellm litellm[proxy] &&
pip install gradio_client==0.2.7 &&
apt-get update &&
apt-get install -y lsof &&
curl -o /workspace/check_and_kill.sh https://raw.githubusercontent.com/ozenhaluk/containers/main/official-templates/pans-base/check_and_kill.sh && 
curl -o /workspace/run_ollama.sh https://raw.githubusercontent.com/ozenhaluk/containers/main/official-templates/pans-base/run_ollama.sh

