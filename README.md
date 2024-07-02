# What is this?

This is a repository with Singularity (also known as Apptainer) definitions that build containers with a number of different image analysis tools and a set of scripts that take care of running a SLURM task that spins up one of those containers. These have been tested on our cluster (Sumner2) - we cannot guarantee the SLURM part of it will work with your cluster but the containers should work on any Linux system!

## Building the container at JAX

Definitions are provided - for many of the containers, we're using the directory /home/user for installation. We don't want any ambiguity between what's container stuff and what's your home directory.

**At JAX, the easiest way to build containers from the definitions in this repository is to use the `build` partition on Sumner2.**
You can access it from a login node by using:  
```bash
sinteractive -p build -q build
```

For more details regarding accessing and using this JAX-specific resource, please see [the instructions in SharePoint](https://jacksonlaboratory.sharepoint.com/sites/ResearchIT/SitePages/JAX-HPC-Pro-Tip.aspx) .
Once you're using the build partition, pick a definition file, click on it, and download it or copy-paste the contents to your Sumner2 user-space and then you can build it using [`singularity build`](https://apptainer.org/docs/user/1.1/build_a_container.html).


## Building the container in the cloud

The Sylabs cloud builder is a universal option to build containers from Singularity definitions. It provides free, but limited
build minutes and container storage. To do use it, you will need to set up an account at https://cloud.sylabs.io/builder  
Once you have an account and are logged in—ideally in a new tab or window—click on the Remote Builder tab at the top.  
Then, in the page that opens, you can copy-paste a definition from this repository into the definition code editor at the top. First delete the example and then click on one of the .def files in this repository browser window, select all of the lines of code, and copy-paste to the empty definition code editor in the Remote Builder pane. At this point, you can also make edits to create a customized container.    
Next, below the code editor, give your container a name, for example for the `qupath_latest.def` one may use: `imageanalysis/qupath:0.4.3`  
Finally, click `Submit Build` and wait for the build to finish successfully—this can take a few minutes!

To pull your container and use it, for example on Sumner2 HPC at JAX, you will need to use `singularity` to connect to the Sylabs cloud, which should be available by default, by using `singularity remote login`. You will be asked to set up an access token at https://cloud.sylabs.io/auth/tokens  
At the top, enter a name for the token—it can be anything, such as `HPC` or `sumner`—and then click `Create Access Token`. The token will be a long string of random characters, so it's best to click the grey button on the right to copy it and then paste it into your terminal window asking for the API key. Once this is completed, you can use `singularity remote list` to ensure that `SylabsCloud` is listed and marked as Active. If it is not, use `singularity remote use SylabsCloud`  
Finally, to pull the example QuPath container from above, use:  
```bash
singularity pull qupath_0_4_3.sif library://<your Sylabs username>/imageanalysis/qupath:0.4.3
```  
For other containers, subsitute the `.sif` file name and the `collection/container-name:tag` as needed—you can copy-paste from the builds listed under My Builds on the Remote Builder tab.

Alternately, if you've cloned this repository or downloaded the definition file you are interested in, after setting up the remote builder as described above, you can build and pull the container in one step, for example:  
```bash
singularity build --remote qupath_0_4_3.sif qupath_latest.def
```

## Using the container on Sumner2

To run a container you need to have the module loaded on a compute node. You can then execute the .sif file, for example:
```bash
./qupath_0_4_3.sif
```
We also provide a convenience script to start a batch job with your container: `./spin_container.sh`. 
As long as your built container is in the same directory, you're good to go. By default, it will run as a job on a 
single core, with 4GB RAM for 10 minutes.

We have two scripts: `open_container.sh` and `spin_container.sh`. You shouldn't need to edit `open_container.sh` for any reason: it's what is passed to a SLURM `srun` call and it just loads the Singularity module and runs the container we built with any arguments you pass. `spin_container.sh` is the script you will run. It has a few useful options that you can find by running `spin_container.sh`. A summary follows:
```
-t  How long the job will run for (default: 10 minutes)
-c  How many cores your job will use (default: 1)
-m  How much memory will be allocated for your job (default: 4GB)
```

