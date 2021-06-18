#!/bin/bash

doRunHelloWorld() {

    source "$PRODUCT_DIR/src/python/tornado-poc/.venv/bin/activate"
    export TORNADO_PORT=8888

    test -d "$HOME/.tornado-poc/logs" || mkdir -p "$HOME/.tornado-poc/logs"
    log_file="$HOME/.tornado-poc/logs/log.out"

    ts=$(date "+%Y%m%d_%H%M%S")
    test -f "$log_file" && mv -v "$log_file" "$log_file-$ts"

    echo -e "\nStarting server at port ${TORNADO_PORT}..."
    echo -e "Logging stdoud and stderr to the file: $log_file\n"

    cd "$PRODUCT_DIR/src/python/tornado-poc"
    
    #poetry install
    poetry run python . | tee 2>&1 "$log_file"  &
    cd "$PRODUCT_DIR"

    sleep 3
    echo -e "curl test hello_world response:"
    curl "http://127.0.0.1:$TORNADO_PORT"
    sleep 600

}