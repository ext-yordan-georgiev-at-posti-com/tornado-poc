doRunPylintInPythonFiles(){
    python3 -m pylint $PRODUCT_DIR/src/python --rcfile=$PRODUCT_DIR/cnf/bin/python/.pylintrc
}
