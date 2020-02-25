#!/bin/sh
module load singularity
rm $2 > /dev/null
singularity run http://s3-far.jax.org/builder/builder $1 $2