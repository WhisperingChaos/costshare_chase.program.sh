#!/bin/bash
test_costshare_chase_program__compose(){
  local -r absComposeExec="$(readlink -f "$0")"
  local -r absComposeDir="$( dirname "$absComposeExec" )"

  local -r callSourcer="$absComposeDir"'/config_sh/vendor/sourcer/sourcer.sh'
  local -r myRoot="$absComposeDir"'/test_costshare_chase_program_sh'
  local component
  for component in $( "$callSourcer" "$myRoot"); do
    source "$component"
  done
}


test_costshare_chase_program__OKI_POKIE(){
  assert_output_true test_costshare_chase__main_OKI_POKIE_expected \
    --- test_costshare_chase_program__OKI_POKIE_generate
}
test_costshare_chase_program__OKI_POKIE_generate(){
  echo "03/27/2021,03/28/2021,OKI POKE,Food & Drink,Sale,-16.97," \
   | ./costshare_chase.program.sh ./component_override/OKI_POKIE
}
test_costshare_chase__main_OKI_POKIE_expected(){
cat<<'OKI_POKIE'
TransactionDate,VendorName,Charge,PartyXpct,SharePartyXRound,SharePartyY,Category,Type
03/27/2021,OKI POKE,-16.97,29,-4.92,-12.05,Food & Drink,Sale
OKI_POKIE
}


test_costshare_chase_program__OKI_POKIE_BJS(){
  assert_output_true test_costshare_chase__main_OKI_POKIE_BJS_expected \
    --- test_costshare_chase_program__OKI_POKIE_BJS_generate
}
test_costshare_chase_program__OKI_POKIE_BJS_generate(){
  test_costshare_chase__main_OKI_POKIE_BJS_in \
  | ./costshare_chase.program.sh ./component_override/OKI_POKIE
}
test_costshare_chase__main_OKI_POKIE_BJS_in(){
cat<<'OKI_POKIE_BJS'
03/27/2021,03/28/2021,OKI POKE,Food & Drink,Sale,-16.97,
03/27/2021,03/28/2021,BJS FUEL,Gas,Sale,-30.00,
OKI_POKIE_BJS
}
test_costshare_chase__main_OKI_POKIE_BJS_expected(){
cat<<'OKI_POKIE_BJS'
TransactionDate,VendorName,Charge,PartyXpct,SharePartyXRound,SharePartyY,Category,Type
03/27/2021,OKI POKE,-16.97,29,-4.92,-12.05,Food & Drink,Sale
03/27/2021,BJS FUEL,-30.00,50,-15.00,-15.00,Gas,Sale
OKI_POKIE_BJS
}


test_costshare_chase_program__OKI_POKIE_fail_BJS(){
  assert_output_true test_costshare_chase__main_OKI_POKIE_fail_BJS_expected \
    --- test_costshare_chase_program__OKI_POKIE_fail_BJS_generate
}
test_costshare_chase_program__OKI_POKIE_fail_BJS_generate(){
  test_costshare_chase__main_OKI_POKIE_fail_BJS_in \
  | ./costshare_chase.program.sh ./component_override/OKI_POKIE
}
test_costshare_chase__main_OKI_POKIE_fail_BJS_in(){
cat<<'OKI_POKIE_BJS'
03/27/2021,03/28/2021,OKI POKE,Food & Drink,Sale,-16.97,
03/27/2021,03/28/2021,BJS Fuel,Gas,Sale,-30.00,
OKI_POKIE_BJS
}
test_costshare_chase__main_OKI_POKIE_fail_BJS_expected(){
cat<<OKI_POKIE_BJS
TransactionDate,VendorName,Charge,PartyXpct,SharePartyXRound,SharePartyY,Category,Type
03/27/2021,03/28/2021,BJS Fuel,Gas,Sale,-30.00,
03/27/2021,OKI POKE,-16.97,29,-4.92,-12.05,Food & Drink,Sale
${assert_REGEX_COMPARE}msgType='Fatal' msg='at least one error or unaccounted for purchase was detected. view output of STDERR' .+$
${assert_REGEX_COMPARE}\+  Caller: file=.+$
${assert_REGEX_COMPARE}\+  Caller: file=.+$
${assert_REGEX_COMPARE}\+  Caller: file=.+$
OKI_POKIE_BJS
}

test_costshare_chase_program_Chase(){
  assert_output_true test_costshare_chase_program_Chase_expected march \
    ---              test_costshare_chase_program_Chase_generate march
}
test_costshare_chase_program_Chase_generate(){
  cat ./data/$1/Statement.csv \
  |   ./costshare_chase.program.sh ./component_override/$1 \
  |   sort
}
test_costshare_chase_program_Chase_expected(){
  cat ./data/$1/SharedExpensesExpected.csv \
  |   sort
}

test_costshare_chase_program__main(){

  test_costshare_chase_program__compose "$0"

  test_costshare_chase_program__OKI_POKIE
  test_costshare_chase_program__OKI_POKIE_fail_BJS
  test_costshare_chase_program_Chase march

  assert_return_code_set
}

test_costshare_chase_program__main
