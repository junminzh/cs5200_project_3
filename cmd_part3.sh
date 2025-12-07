#******************** Part 3 Script ********************#
GEM5_DIR=/root/uccs/cs5200_ca/projects/gem5
PY_FILE=${GEM5_DIR}/configs/example/gem5_library/x86-gapbs-benchmarks.py
GEM5_OPT=${GEM5_DIR}/build/X86/gem5.opt
SAVE_DIR=/root/uccs/cs5200_ca/project3/cs5200_project_3/output_part_3
mkdir -p ${SAVE_DIR}

ARGS="--benchmark gapbs-cc-small --l1i-rp LRU --l1d-rp MrClean --l2-rp MrClean"

# policies=("Random" "LRU" "TreePLRU" "LIP" "MRU" "FIFO" "SecondChance")
# policies=("Random" "LRU")
# policies=("TreePLRU" "LIP" "MRU" "FIFO" "SecondChance")
# for L2_rp in "${policies[@]}"; do
#     echo "Running L1i-rp=LRU, L1d-rp=TreePLRU, L2-rp=MrClean"        
#     ${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS} --l2-rp ${L2_rp}
    
#     echo "Storing config files:"
#     cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config-l1i-LRU-lid-TreePLRU-l2-${L2_rp}.ini
#     cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats-l1i-LRU-lid-TreePLRU-l2-${L2_rp}.txt
# done
echo "Running L1i-rp=LRU, L1d-rp=TreePLRU, L2-rp=MrClean:" 
${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS}

echo "Storing config files:"
cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config-l1i-LRU-lid-MrClean-l2-MrClean.ini
cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats-l1i-LRU-lid-MrClean-l2-MrClean.txt
