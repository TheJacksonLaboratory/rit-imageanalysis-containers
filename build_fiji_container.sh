#!/bin/sh
module load singularity
rm ubuntu_with_fiji.sif > /dev/null
singularity run http://s3-far.jax.org/builder/builder ubuntu_with_fiji.rec ubuntu_with_fiji.sif