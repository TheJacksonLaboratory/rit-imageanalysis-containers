#!/bin/sh


usage="$(basename "$0") [-h] [-t time -c cores -m memory --fiji-args "arguments"] -- spins up a Singularity container with Fiji with the given specifications.

where:
    -h  show this help text
    -t  How long the job will run for (default: 10 minutes)
    -c  How many cores your job will use (default: 1)
    -m  How much memory will be allocated for your job (default: 4GB)
    --fiji-args  Any argument you might want to pass to Fiji (default: the same amount of memory as -m specifies)

    Fiji can take a lot of command-line arguments; a comprehensive list is can be obtained by running any Fiji executable you might have with ImageJ-XXXXXX --help"



time = "00-10:00"
cores = "1"
memory = "4000"

while [ "$#" -gt 0 ]; do
  case "$1" in
    -t|--time) time="$2"; shift 2;;
    -m|--memory) memory="$2"; shift 2;;
    -c|--cores) cores="$2"; shift 2;;

    --fiji-args) arguments="$2"; shift 2;;
    --time|--memory|--cores|fiji-args) echo "$1 requires an argument" >&2; exit 1;;

    -*) echo "unknown option: $1" >&2; exit 1;;
    *) handle_argument "$1"; shift 1;;
  esac
done


arguments="--mem=$memory $arguments"


command="srun -n $cores -t $time --mem=$memory --pty --x11 open_fiji.sh $arguments"
echo $command

$command