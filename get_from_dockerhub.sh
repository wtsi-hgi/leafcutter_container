#!/usr/bin/env bash                                                                                                                         
                                                                                                                                            
mkdir -p cache_dir                                                                                                                          
export SINGULARITY_CACHEDIR=$PWD/cache_dir                                                                                                  
                                                                                                                                            
mkdir -p tmp_dir                                                                                                                            
export TMPDIR=$PWD/tmp_dir                                                                                                                  
                                                                                                                                            
# see https://github.com/wtsi-hgi/leafcutter_container                                                                                                     
rm -f leafcutter.sif                                                                                                                                       
rm -f leafcutter.img                                                                                                                                       
singularity pull docker://wtsihgi/leafcutter                                                                                                               
mv leafcutter_latest.sif leafcutter.img                                                                                                                           
                                                                                                                                                           
rm -r cache_dir                                                                                                                                            
rm -r tmp_dir      
