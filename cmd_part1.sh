# #******************** Part 1_0 Script ********************#
# GEM5_DIR=/root/uccs/cs5200_ca/projects/gem5
# PY_FILE=${GEM5_DIR}/configs/example/gem5_library/x86-gapbs-benchmarks.py
# GEM5_OPT=${GEM5_DIR}/build/X86/gem5.opt
# # GEM5_OPT=${GEM5_DIR}/build/X86_P3/gem5.opt

# SAVE_DIR=/root/uccs/cs5200_ca/project3/cs5200_project_3/output_part1_no_diff
# # SAVE_DIR=/root/uccs/cs5200_ca/project3/cs5200_project_3/output_part1_apl_diff
# mkdir -p ${SAVE_DIR}

# echo "Simulating:"
# # ARGS="--cmd=${EXE_DIR}${EXE} --cpu-type=${isa_cpu}TimingSimpleCPU"
# ARGS="--benchmark gapbs-cc-test"
# ${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS}

# echo "Storing config files:"
# cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config_p1.0.ini
# cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats_p1.0.txt


#******************** Part 1_2 Script ********************#
GEM5_DIR=/root/uccs/cs5200_ca/projects/gem5
PY_FILE=${GEM5_DIR}/configs/example/gem5_library/x86-gapbs-benchmarks.py
GEM5_OPT=${GEM5_DIR}/build/X86/gem5.opt
SAVE_DIR=/root/uccs/cs5200_ca/project3/cs5200_project_3/output_part_1_2
mkdir -p ${SAVE_DIR}

ARGS="--benchmark gapbs-cc-small"

policies=("Random" "LRU" "TreePLRU" "LIP" "MRU" "FIFO" "SecondChance")
# policies=("Random" "LRU")
for L1i_rp in "${policies[@]}"; do
    for L1d_rp in "${policies[@]}"; do
        echo "Running L1i-rp=${L1i_rp}, L1d-rp=${L1d_rp}:"        
        ${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS} --l1i-rp ${L1i_rp} --l1d-rp ${L1d_rp}

        echo "Storing config files:"
        cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config-l1i-${L1i_rp}-lid-${L1d_rp}.ini
        cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats-l1i-${L1i_rp}-lid-${L1d_rp}.txt
    done
done
