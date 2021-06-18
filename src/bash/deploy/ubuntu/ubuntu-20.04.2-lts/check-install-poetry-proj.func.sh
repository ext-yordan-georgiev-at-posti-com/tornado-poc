#!/bin/bash
do_check_install_poetry_proj(){

    cd "$PRODUCT_DIR/src/python/tornado-poc"
    
    poetry install
	cd "$PRODUCT_DIR/src/python/tornado-poc"
	poetry install
	cd "$PRODUCT_DIR"
	 
}
