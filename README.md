What is this?
========================
This is a repository with Singularity definitions that build containers with a number of different image analysis tools and a set of scripts that take care of running a SLURM task that spins up one of those containers. These have been tested on our cluster (sumner) - I cannot guarantee the SLURM part of it will work with your cluster but the containers should work on any Linux system!

Building the container
========================
Definitions are provided - for many of the containers, we're using the directory /home/user for installation. We don't want any ambiguity between what's container stuff and what's your home directory.

At JAX, the easiest way to build containers from the 
The easiest way to build containers from the definitions in this repository is to use the Sylabs cloud builder.  
To do this, you will need to set up an account at https://cloud.sylabs.io/builder  
Once you have an account and are logged in—ideally in a new tab or window—click on the Remote Builder tab at the top.  
Then, in the page that opens, you can copy-paste a definition from this repository into the definition code editor at the top. First delete the example and then click on one of the .rec files in this repository browser window, select all of the lines of code, and copy-paste to the empty definition code editor in the Remote Builder pane. At this point, you can also make edits to create a customized container.    
Next, below the code editor, give your container a name, for example for the `qupath_latest.rec` one may use: `imageanalysis/qupath:0.4.3`  
Finally, click `Submit Build` and wait for the build to finish successfully—this can take a few minutes!

To pull your container and use it, for example on Sumner HPC at JAX, you will need to use `singularity` to connect to the Sylabs cloud, which should be available by default, by using `singularity remote login`. You will be asked to set up an access token at https://cloud.sylabs.io/auth/tokens  
At the top, enter a name for the token—it can be anything, such as `HPC` or `sumner`—and then click `Create Access Token`. The token will be a long string of random characters, so it's best to click the grey button on the right to copy it and then paste it into your terminal window asking for the API key. Once this is completed, you can use `singularity remote list` to ensure that `SylabsCloud` is listed and marked as Active. If it is not, use `singularity remote use SylabsCloud`  
Finally, to pull the example QuPath container from above, use:  
```
singularity pull qupath_0_4_3.sif library://<your Sylabs username>/imageanalysis/qupath:0.4.3
```  
For other containers, subsitute the `.sif` file name and the `collection/container-name:tag` as needed—you can copy-paste from the builds listed under My Builds on the Remote Builder tab.

Alternately, if you've cloned this repository or downloaded the .rec files, after setting up the remote builder as described above, you can build and pull the container in one step, for example:  
```
singularity build --remote qupath_0_4_3.sif qupath_latest.rec
```

Finally, if you're at JAX, you can use the JAX remote builder to build your container on sumner, as follows:  
```
singularity run http://s3-far.jax.org/builder/builder <RECIPEFILE> <CONTAINERFILE>
``` 
Note: this is currently deprecated in favor of the Sylabs cloud builder.

Alternatively, you can use our `build_container.sh` script to build it. On sumner, you just need to run it using something like 

```
srun -n 1 -t 00-10:00 -q batch build_container.sh <RECIPEFILE> <CONTAINERFILE>
```

Note that the login nodes do not have Singularity enabled, so you need to request a compute node!

You should now have a container file in your directory.

> **Warning** 
> If you want to change anything in the definition and rebuild the container, you will need to delete your local .sif file! The remote builder does not overwrite by default. Using our script to build it gets rid of this issue.

Using the container on sumner
========================
If you just want to run a container: `./spin_container.sh`. As long as your built container is in the same directory, you're good to go. It will run as a job on a single core, with 4GB RAM for 10 minutes.

We have two scripts: `open_container.sh` and `spin_container.sh`. You shouldn't need to edit `open_container.sh` for any reason: it's what is passed to a SLURM `srun` call and it just loads the Singularity module and runs the container we built with any arguments you pass. `spin_container.sh` is the script you will run. It has a few useful options that you can find by running `spin_container.sh`. A summary follows:
```
-t  How long the job will run for (default: 10 minutes)
-c  How many cores your job will use (default: 1)
-m  How much memory will be allocated for your job (default: 4GB)
```

