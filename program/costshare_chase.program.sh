#!/bin/bash
###############################################################################
##
##  Purpose
##    A stub program used to compose the actual one from its constituent
##    modules.
##  Why
##    Enables direct testing of all functions supporting primary features
##    by the test framework without tripping over the main entry point defined
##    within this stub. 
##    
##  Note
##    Adheres to "SOLID bash" principles:
##    https://github.com/WhisperingChaos/SOLID_Bash#solid_bash
##
###############################################################################

####################### Interface Hook/Callback Functions ######################
##
##  Please refer to the component named: costshare.chase.source.sh whose source
##  is included when constructing this program.
##
###############################################################################

############################ private implementation ###########################
#
#   The code below shouldn't change unless there's a bug.
#
###############################################################################

costshare_chase__executable_compose(){
  local -r absComposeExec="$(readlink -f "$1")"
  local -r absComposeDir="$( dirname "$absComposeExec" )"

  local -r callSourcer="$absComposeDir"'/config_sh/vendor/sourcer/sourcer.sh'
  local -r myRoot="$absComposeDir"'/costshare_chase_program_sh'
  local component
  for component in $( "$callSourcer" "$myRoot"); do
    source "$component"
  done
}

costshare_chase__main(){
  costshare_chase__executable_compose "$0"

  costshare_chase__executable_run "$0" "$@"
}

costshare_chase__main "$@"
