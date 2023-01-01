#! /bin/bash

print_usage() {
        echo "$0 -o [outputdir] -p [sample_name, prefix] -I [transcriptome_index] -h"
        echo "<options>"
        echo "  -o [outputdir] : directory for output ex) /User/hojin/Desktop/hcc"
        echo "  -p [sample_name, prefix] : /path/to/fastgz/prefix"
        echo "                            sample_name.1.fastq.gz sample_name.2.fastq.gz"
        echo "  -I [transcriptome_index] : /path/to/salmon_index"
        echo "  -h : show this message"
}

while getopts o:p:I:h opts; do
        case ${opts} in
                o) Opt_out=$OPTARG
                        ;;
                p) Opt_prefix=$OPTARG
                        ;;
                I) Opt_index=$OPTARG
                        ;;
                h) print_usage
                        exit;;
        esac
done

### prefix ###
prefix=`basename ${Opt_prefix}`
mkdir ${Opt_out}/${prefix}

### fastqc ###
arr=(`ls ${Opt_prefix}* | grep "${Opt_prefix}"`)
fastqc -o ${Opt_out}/${prefix} ${arr[0]} ${arr[1]} -f fastq

### salmon ###
salmon quant -i ${Opt_index} -l A -1 ${arr[0]} -2 ${arr[1]} -p 8 --validateMappings -o ${Opt_out}/${prefix}
