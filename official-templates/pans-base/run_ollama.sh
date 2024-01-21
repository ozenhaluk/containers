#!/bin/bash


# Function to wait for a specific output in log files.
wait_for_log() {
  local logfile=$1
  local search_string=$2
  local timeout=$3
  local search_alternative=$4
  local start_time=$(date +%s)

  while true; do
    # echo "Waiting for '$search_string' in $logfile."
    if grep -q "$search_string" "$logfile"; then
      echo "+ Found '$search_string' in $logfile."
      return 0
    fi

    if [[ -n "$search_alternative" ]]; then
      if grep -q "$search_alternative" "$logfile"; then
        echo "! Found '$search_alternative' in $logfile."
        return 0
      fi
    fi

    local current_time=$(date +%s)
    local elapsed_time=$((current_time - start_time))

    if [[ $elapsed_time -ge $timeout ]]; then
      echo "Timeout reached while waiting for '$search_string' or '$search_alternative' in $logfile."
      exit 1
    fi

    sleep 1
  done
}

# Function to run a model and wait for it to be ready
run_model() {
  local model_name=$1
  local port=$2

  # Run the ollama model and wait for it to be ready
  ollama pull $model_name > .log/ollama_pull_$model_name.log 2>&1 &
  wait_for_log ".log/ollama_pull_$model_name.log" "success" 300

  # Start the litellm model and wait for it to be ready
  litellm --host 0.0.0.0 --port $port --model ollama/$model_name --add_function_to_prompt --debug > .log/litellm_$model_name.log 2>&1 &
  wait_for_log ".log/litellm_$model_name.log" "Uvicorn running on http://0.0.0.0:$port" 30 "address already in use"
}

#create log directory if it doesn't exist
mkdir -p .log

echo "Starting run Ollama script..."

# Start ollama serve and wait for it to be ready
ollama serve > .log/ollama_serve.log 2>&1 &
wait_for_log ".log/ollama_serve.log" "Listening on" 30 "address already in use"

# Convert the command-line arguments to an array
args=("$@")

# Run each model specified as a pair of command-line arguments
for ((i=0; i<$#; i+=2)); do
  run_model ${args[$i]} ${args[$i+1]}
done