#******************** Part 4 Script ********************#
GEM5_DIR=/root/uccs/cs5200_ca/projects/gem5
PY_FILE=${GEM5_DIR}/configs/example/gem5_library/x86-gapbs-benchmarks.py
GEM5_OPT=${GEM5_DIR}/build/X86/gem5.opt
SAVE_DIR=/root/uccs/cs5200_ca/project3/cs5200_project_3/output_part_4
mkdir -p ${SAVE_DIR}

# Use MrClean at the L1d cache only
ARGS="--benchmark gapbs-cc-medium --l1i-rp LRU --l1d-rp MrClean --l2-rp TreePLRU"
echo "Running L1i-rp=LRU, L1d-rp=MrClean, L2-rp=TreePLRU:" 
${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS}

echo "Storing config files:"
cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config-l1i-LRU-lid-MrClean-l2-TreePLRU.ini
cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats-l1i-LRU-lid-MrClean-l2-TreePLRU.txt


# Use MrClean at the L2 cache only
ARGS="--benchmark gapbs-cc-medium --l1i-rp LRU --l1d-rp TreePLRU --l2-rp MrClean"
echo "Running L1i-rp=LRU, L1d-rp=TreePLRU, L2-rp=MrClean:" 
${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS}

echo "Storing config files:"
cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config-l1i-LRU-lid-TreePLRU-l2-MrClean.ini
cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats-l1i-LRU-lid-TreePLRU-l2-MrClean.txt


# Use MrClean at the L1d and L2 caches
ARGS="--benchmark gapbs-cc-medium --l1i-rp LRU --l1d-rp MrClean --l2-rp MrClean"
echo "Running L1i-rp=LRU, L1d-rp=MrClean, L2-rp=MrClean:" 
${GEM5_OPT} -d ${GEM5_DIR}/m5out ${PY_FILE} ${ARGS}

echo "Storing config files:"
cp ${GEM5_DIR}/m5out/config.ini ${SAVE_DIR}/config-l1i-LRU-lid-MrClean-l2-MrClean.ini
cp ${GEM5_DIR}/m5out/stats.txt ${SAVE_DIR}/stats-l1i-LRU-lid-MrClean-l2-MrClean.txt