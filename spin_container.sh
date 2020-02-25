#!/bin/sh


usage="$(basename "$0") [-h] [-t time -c cores -m memory ] -- spins up a Singularity container with the given specifications.

where:
    -h  show this help text
    -t  How long the job will run for (default: 10 minutes)
    -c  How many cores your job will use (default: 1)
    -m  How much memory will be allocated for your job (default: 4GB)
    
"

##Default options in case user doesn't pass any arguments
time="00-10:00"
cores="1"
memory="4000"

##Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -t|--time) time="$2"; shift 2;;
    -m|--memory) memory="$2"; shift 2;;
    -c|--cores) cores="$2"; shift 2;;

    
    --time|--memory|--cores) echo "$1 requires an argument" >&2; exit 1;;
    -h) echo "$usage"; exit 0;;
    -*) echo "unknown option: $1" >&2; exit 1;;
    *) shift 1;;
  esac
done



## Build and run an srun command on batch queue
command="srun -n $cores -t $time --mem=$memory -q batch --pty --x11 $@"
echo $command

$command