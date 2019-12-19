#What is this?
This is a Singularity recipe that builds a container with Fiji (on Ubuntu) and a set of scripts that take care of running a SLURM task that spins up that container. These have been tested on sumner on 12/19/19 - things might change in the future!

#Building the container
========================
Recipe provided - we're using the directory /home/user in the container for installation. There are two reasons for that: 
1) The remote builder does not honor your local $HOME variable;
2) We don't want any ambiguity between what's container stuff and what's your home directory.
To build it, run  
`singularity run http://s3-far.jax.org/builder/builder ubuntu_with_fiji.rec ubuntu_with_fiji.sif` 
You should now have a `ubuntu_with_fiji.sif` file in your directory.
(reminder: if you want to change anything on the recipe and rebuild the container, you will need to delete your local copy! The remote builder does not overwrite by default.)

#Using the container on sumner
========================
We have two scripts: `open_fiji.sh` and `spin_fiji.sh`. You shouldn't need to edit `open_fiji.sh` for any reason: it's what is passed to a SLURM `srun` call and it just loads the Singularity module and runs the container we built with any arguments you pass. `spin_fiji.sh` is the script you will run. It has a few useful options that you can find by running `spin_fiji.sh`. A summary follows:
    -t  How long the job will run for (default: 10 minutes)
    -c  How many cores your job will use (default: 1)
    -m  How much memory will be allocated for your job (default: 4GB)
    --fiji-args  Any argument you might want to pass to Fiji (default: the same amount of memory as -m specifies)

Fiji can take a lot of command-line arguments; a comprehensive list is can be obtained by running any Fiji executable you might have with `ImageJ-XXXXXX --help`. A very outdated list of possible arguments is also found at https://imagej.nih.gov/ij/docs/guide/146-18.html , but I wouldn't trust it. 
A useful thing you can do with command-line arguments is telling Fiji which folder to use for finding plugins, jar files and macros. Since your home folder is mapped into the Singularity container, you can have your personalised Fiji folder in your home directory with all your favourite plugins and just point the container version to that. 

#Known issues
========================
There is some weirdness with X11 forwarding and the main Fiji window that makes it VERY hard to use at the moment. 


