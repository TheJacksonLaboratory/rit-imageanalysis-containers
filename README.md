What is this?
========================
This is a repository with Singularity recipes that build containers with a number of different image analysis tools and a set of scripts that take care of running a SLURM task that spins up one of those containers. These have been tested on our cluster (sumner) - I cannot guarantee the SLURM part of it will work with your cluster but the containers should work on any Linux system!

Building the container
========================
Recipes are provided - for many of the containers, we're using the directory /home/user for installation. We don't want any ambiguity between what's container stuff and what's your home directory.

To build it on sumner, run  
`singularity run http://s3-far.jax.org/builder/builder <RECIPEFILE> <CONTAINERFILE>` 

Alternatively, you can use our `build_container.sh` script to build it. On sumner, ou just need to run it using something like 

```
srun -n 1 -t 00-10:00 -q batch build_container.sh <RECIPEFILE> <CONTAINERFILE>
```

Note that the login nodes do not have Singularity enabled, so you need to request a compute node!

You should now have a container file in your directory.

(reminder: if you want to change anything on the recipe and rebuild the container, you will need to delete your local copy! The remote builder does not overwrite by default. Using our script to build it gets rid of this issue.)

Using the container on sumner
========================
If you just want to run a container: `./spin_container.sh`. As long as your built container is in the same directory, you're good to go. It will run as a job on a single core, with 4GB RAM for 10 minutes.

We have two scripts: `open_container.sh` and `spin_container.sh`. You shouldn't need to edit `open_container.sh` for any reason: it's what is passed to a SLURM `srun` call and it just loads the Singularity module and runs the container we built with any arguments you pass. `spin_container.sh` is the script you will run. It has a few useful options that you can find by running `spin_container.sh`. A summary follows:
```
-t  How long the job will run for (default: 10 minutes)
-c  How many cores your job will use (default: 1)
-m  How much memory will be allocated for your job (default: 4GB)
```

