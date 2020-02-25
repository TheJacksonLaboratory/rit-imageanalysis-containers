#!/bin/sh
module load singularity
echo $3
rm $3 > /dev/null
singularity run http://s3-far.jax.org/builder/builder $2 $3