#!/bin/bash
compose_executable(){
  local -r callFromDir="$( dirname "$1" )"

  local -r callSourcer="$callFromDir"'/config_sh/vendor/sourcer/sourcer.sh'
  local -r myRoot="$callFromDir"'/costshare_chase_test_sh'
  local mod
  for mod in $( "$callSourcer" "$myRoot"); do
    source "$mod"
  done
}


test_costshare_chase__csv_transform(){

  assert_true '
    echo "\""
    | costshare_chase__csv_transform 2>&1
    | assert_output_true test_costshare_chase__csv_transform_bad_CSV'

  assert_true '
    echo
    | costshare_chase__csv_transform 2>&1
    | assert_output_true test_costshare_chase__csv_transform_missing_required'

  assert_true '
    echo ",fieldIgnore,vendorName,fieldIgnore,tranType,amtVal"
    | costshare_chase__csv_transform 2>&1
    | assert_output_true test_costshare_chase__csv_transform_required_null'

  assert_true '
    echo "10/10,,vendorName,category,Return,100.00"
    | costshare_chase__csv_transform 2>&1
    | assert_output_true echo "10/10,vendorName,100.00,category"'

  assert_true '
    echo "10/10/2022,,vendorName,category,Sale,-100.00"
    | costshare_chase__csv_transform 2>&1
    | assert_output_true echo "10/10/2022,vendorName,-100.00,category"'

  assert_true '
    test_costshare_chase__csv_transform_multi_row_input
    | costshare_chase__csv_transform 2>&1
    | assert_output_true test_costshare_chase__csv_transform_multi_row_expected'
}
test_costshare_chase__csv_transform_bad_CSV(){
cat <<bad_CSV
${assert_REGEX_COMPARE}msgType='Fatal' msg='problem reading Chase CSV .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
bad_CSV
}
test_costshare_chase__csv_transform_missing_required(){
cat <<missing_required
${assert_REGEX_COMPARE}msgType='Fatal' msg='missing required field not set. .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
missing_required
}
test_costshare_chase__csv_transform_required_null(){
cat <<required_null
${assert_REGEX_COMPARE}msgType='Fatal' msg='missing required field set to null string\..*,fieldIgnore,vendorName,fieldIgnore,tranType,amtVal.+
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
${assert_REGEX_COMPARE}\+  Caller: .*
required_null
}
test_costshare_chase__csv_transform_multi_row_input(){
cat <<'multi_row_input'
10/10/2021,,vendorName,Food,Sale,-100000.00
10/10/2022,,vendor Name,Gas,Return,100000.00
10/10/2023,,vendor Na me,Category,Sale,-0.99
10/10/2023,,vendor Na m e,,Payment,2013.95
multi_row_input
}
test_costshare_chase__csv_transform_multi_row_expected(){
cat <<'multi_row_expected'
10/10/2021,vendorName,-100000.00,Food
10/10/2022,vendor Name,100000.00,Gas
10/10/2023,vendor Na me,-0.99,Category
multi_row_expected
}

test_costshare_chase__main(){
  assert_output_true \
    test_costshare_chase__main_OKI_POKIE \ 
    --- \
    test_costshare_chase__main_1
}
test_costshare_chase__main_1(){

  test_costshare_chase__main_only_Food_and_Drink
  echo testpid=$$
  trap "return 0;"  SIGUSR1
  trap "return 1;" SIGUSR2

  echo '03/27/2021,03/28/2021,OKI POKE,Food & Drink,Sale,-16.97,' \
  | costshare_chase__pileline_-run 2> >( costshare_chase__detect_error $testpid  >&2 )
  while sleep 1; do
    :
  done
#  &\
#  | assert_output_true test_costshare_chase__main_OKI_POKIE
# assert_true '[[ $? -ne 0 ]]'

#  echo '03/27/2021,03/28/2021,NOKI POKE,Food & Drink,Sale,-16.97,' \
#  | costshare_chase__pileline_run  2> >( costshare_chase__detect_error $testpid  >&2 )
#  echo $?

}
test_costshare_chase__main_only_Food_and_Drink(){

costshare_chase_vendor_pct_tbl(){
cat <<'vendor_pct'
Vendor		, PCT
OKI POKE	,  29
vendor_pct
}
costshare_chase_purchases_excluded_tbl(){
return
}
costshare_chase_category_filter_tbl(){
cat <<'category_filter_tbl'
,Food & Drink,
category_filter_tbl
}
costshare_chase_purchases_exclude_specific_category_matches_tbl(){
return
}
}
test_costshare_chase__main_OKI_POKIE(){
cat<<'OKI_POKIE'
TransactionDate,VendorName,Charge,OffSpngPctShare,OffSpngShareAmt,ParentShareAmt,Category
03/27/2021,OKI POKE,-16.97,29,-4.92,-12.05,Food & Drink
stiff
OKI_POKIE
}


test_costshare_chase_main(){
  compose_executable "$0"
  test_costshare_chase__main
  assert_return_code_set
}

test_costshare_chase_main
