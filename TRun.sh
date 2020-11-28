#!/bin/sh
cd `dirname $0`
chmod 755 ./bin/*
xattr -dr com.apple.quarantine ./bin

# Project settings
#BASENAME=sample1
BASENAME=reuben-t
NumThreads=6

# musicXML_to_label
SUFFIX=musicxml

# NEUTRINO
ModelDirs=(KIRITAN ITAKO)
#ModelDir=KIRITAN

# WORLD
PitchShifts=(1.0 1.00)
FormantShifts=(1.00 1.00)

# PATH to current library
export DYLD_LIBRARY_PATH=$PWD/bin:$DYLD_LIBRARY_PATH

echo "`date +"%M:%S"` : start MusicXMLtoLabel"
./bin/musicXMLtoLabel "score/musicxml/${BASENAME}.${SUFFIX}" "score/label/full/${BASENAME}.lab" "score/label/mono/${BASENAME}.lab"

echo "`date +"%M:%S"` : start NEUTRINO"
for i in "${!ModelDirs[@]}"
do

ModelDir="${ModelDirs[i]}"
FormantShift="${FormantShifts[i]}"
PitchShift="${PitchShifts[i]}"
echo "${ModelDir}"
echo "${FormantShift}"

echo "score/label/full/${BASENAME}.lab"
echo "score/label/timing/${ModelDir}-${BASENAME}.lab" 
echo "./output/${ModelDir}-${BASENAME}.f0"
echo "./output/${ModelDir}-${BASENAME}.mgc"
echo "./output/${ModelDir}-${BASENAME}.bap"
echo "./model/${ModelDir}/"

./bin/NEUTRINO "score/label/full/${BASENAME}.lab" "score/label/timing/${modelDir}-${BASENAME}.lab" "./output/${ModelDir}-${BASENAME}.f0" "./output/${ModelDir}-${BASENAME}.mgc" "./output/${ModelDir}-${BASENAME}.bap" "./model/${ModelDir}/" -n ${NumThreads} -t

echo "`date +"%M:%S"` : start WORLD"
./bin/WORLD "output/${ModelDir}-${BASENAME}.f0" "output/${ModelDir}-${BASENAME}.mgc" "output/${ModelDir}-${BASENAME}.bap" -f ${PitchShift} -m ${FormantShift} -o "output/${ModelDir}-${BASENAME}_syn.wav" -n ${NumThreads} -t

done

echo "`date +"%M:%S"` : END"
