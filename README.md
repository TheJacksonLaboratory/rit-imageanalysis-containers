# singularity_fiji_slurm
Making it easier for users to spin up a Singularity container with Fiji from a slurm-based cluster


# Building
Singularity image (ubuntu_with_fiji.sif) needs to be built from existing recipe. It uses debootstrap for bootstrapping, so you'll need that. Everything else should be smooth sailing.

# Instructions
Just run spin_fiji.sh on your cluster of choice. Usage:

```spin_fiji.sh [-h] [-t time -c cores -m memory --fiji-args "arguments"] -- spins up a Singularity container with Fiji with the given specifications.

where:
    -h  show this help text
    -t  How long the job will run for (default: 10 minutes)
    -c  How many cores your job will use (default: 1)
    -m  How much memory will be allocated for your job (default: 4GB)
    --fiji-args  Any argument you might want to pass to Fiji (default: the same amount of memory as -m specifies)

    Fiji can take a lot of command-line arguments; a comprehensive list is can be obtained by running any Fiji executable you might have with ImageJ-XXXXXX --help"
```
