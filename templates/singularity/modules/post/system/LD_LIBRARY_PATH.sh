# $SINGULARITY_ENVIRONMENT will be located at /.singularity.d/env/91-environment.sh
# echo $SINGULARITY_ENVIRONMENT # /.singularity.d/env/91-environment.sh # at runtime

echo export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib:/usr/local/lib64 > $SINGULARITY_ENVIRONMENT
