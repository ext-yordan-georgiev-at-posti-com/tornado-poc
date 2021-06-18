do_use_python_venv(){
   command -v python3 && \
   test -f $PRODUCT_DIR/venv/bin/activate && \
   . $PRODUCT_DIR/venv/bin/activate
}