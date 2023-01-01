#! /bin/bash

print_usage() {
        echo "$0 -i [sample_dir] -f -s  -h"
        echo "<options>"
        echo "  -i [sample_dir] : /path/to/results of rnaseq_salmon_Nov132022_hj.sh"
        echo "  -f : fastqc "
        echo "  -s : salmon "
        echo "  -h : show this message"
}

while getopts i:fsh opts; do
        case ${opts} in
                i) Opt_dir=$OPTARG
                        ;;
                f) Opt_fastqc=1
                        ;;
                s) Opt_salmon=1
                        ;;
                h) print_usage
                        exit;;
        esac
done

### module load ###
module purge
module load MultiQC/1.10.1-foss-2020b-Python-3.8.6

rm -rf ${Opt_dir}/file_list.txt

### fastqc results ###
if [[ ${Opt_fastqc} -eq 1 ]]
then
        ls ${Opt_dir}/*/*_fastqc.zip >> ${Opt_dir}/file_list.txt
fi

### salmon results ###
if [[ ${Opt_salmon} -eq 1 ]]
then
        #ls ${Opt_dir}/*/logs/salmon_quant.log >> ${Opt_dir}/file_list.txt
        ls ${Opt_dir}/*/aux_info/meta_info.json >> ${Opt_dir}/file_list.txt
        ls ${Opt_dir}/*/libParams/flenDist.txt >> ${Opt_dir}/file_list.txt
fi

### multiqc ###
# -f : overwirte multiqc report file 
multiqc -f --file-list ${Opt_dir}/file_list.txt
