#!/bin/sh
cd `dirname $0`
chmod 755 ./bin/*
xattr -dr com.apple.quarantine ./bin

# Project settings
#BASENAME=sample1
BASENAME=reuben-b
NumThreads=3

# musicXML_to_label
SUFFIX=musicxml

# NEUTRINO
ModelDir=KIRITAN

# WORLD
PitchShift=1.0
FormantShift=1.0

# PATH to current library
export DYLD_LIBRARY_PATH=$PWD/bin:$DYLD_LIBRARY_PATH

echo "`date +"%M:%S"` : start MusicXMLtoLabel"
./bin/musicXMLtoLabel "score/musicxml/${BASENAME}.${SUFFIX}" "score/label/full/${BASENAME}.lab" "score/label/mono/${BASENAME}.lab"

echo "`date +"%M:%S"` : start NEUTRINO"
./bin/NEUTRINO "score/label/full/${BASENAME}.lab" "score/label/timing/${BASENAME}.lab" "./output/${BASENAME}.f0" "./output/${BASENAME}.mgc" "./output/${BASENAME}.bap" "./model/${ModelDir}/" -n ${NumThreads} -t

echo "`date +"%M:%S"` : start WORLD"
./bin/WORLD "output/${BASENAME}.f0" "output/${BASENAME}.mgc" "output/${BASENAME}.bap" -f ${PitchShift} -m ${FormantShift} -o "output/${BASENAME}_syn.wav" -n ${NumThreads} -t

echo "`date +"%M:%S"` : END"
