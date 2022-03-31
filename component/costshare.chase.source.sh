#!/bin/bash
###############################################################################
##
##  costshare_chase
##
##  Purpose
##    Transform Chase Credit Card CSV output into the CSV input (interface).
##    
##  Note
##    Adheres to "SOLID bash" principles:
##    https://github.com/WhisperingChaos/SOLID_Bash#solid_bash
##
###############################################################################

###############################################################################
##
##  Purpose
##    Execute the entire pipeline Chase CSV transform and reporting pipeline.
##  why
##    Encapsulates the entire pipeline in a function allowing for the detection
##    of lower level errors, whose return values are potentially masked
##    by the use of bash process substitution.
##  In
##    STDIN  - Chase Credit Card CSV.
##  Out
##    STDOUT - Purchase format required by costshare.source.sh
##    STDERR - A purchase exclusion report, error and fatal messages.
##    SIGUSR1- A Linux signal indicating the absense of errors and implicitly
##             excluded purchases.
##    SIGUSR2- A Linux signal indicating errors or a purchase(s) might be
##             implicitly excluded from cost sharing.
###############################################################################
costshare_chase__pileline_run(){

  set -o pipefail
  echo 'TransactionDate,VendorName,Charge,OffSpngPctShare,OffSpngShareAmt,ParentShareAmt,Category'
  grep -v  'Transaction Date,Post Date,Description,Category,Type,Amount,Memo'  \
  | grep --fixed-strings -f <( costshare_chase_category_filter_tbl ) \
  | costshare_chase__csv_expected  \
  | costshare_chase__vendor_exclusion_report \
  | costshare_charge_share_run
}
###############################################################################
##
##  Purpose
##    Transforms Chase Credit Card purchases encoded CSV to the CSV format
##    required by the supported by the public "run" function of
##    costshare.source.sh.  
##  In
##    STDIN  - Chase Credit Card CSV.
##  Out
##    STDOUT - Purchase format required by costshare.source.sh
###############################################################################
declare -g -r costshare_chase__AMTDEC_REGEX='^[[:space:]]*(([+]|[-])?([0-9]+(\.[0-9][0-9])?))[[:space:]]*$'
costshare_chase__csv_expected(){

   local purchase
   local purchaseCnt
   local -i fieldUnset=0
   local transDate
   local fieldIgnore
   local vendorName
   local category
   local transType
   local amt
   local amtVal
   local amtSign
   local costshareCSVformat
   while read -r purchase; do

    (( purchaseCnt++ ))
    transDate=''
    fieldIgnore=''
    vendorName=''
    transType=''
    amtVal=''
    if ! csv_field_get "$purchase" fieldUnset transDate fieldIgnore vendorName category transType amtVal 2>\dev\null; then
      msg_fatal "problem reading Chase CSV purchase='$purchase' purchaseCnt=$purchaseCnt"
    fi

    if [[ $fieldUnset -ne 0 ]]; then
      msg_fatal "missing required field not set. purchase='$purchase' purchaseCnt=$purchaseCnt"
    fi

    if [[ -z "$vendorName" ]] \
    || [[ -z "$amtVal" ]]     \
    || [[ -z "$transDate" ]]  \
    || [[ -z "$transType" ]]; then
      msg_fatal "missing required field set to null string. purchase='$purchase' purchaseCnt=$purchaseCnt'"
    fi
    
    if [[ "$transType" != "Sale" ]]; then
     continue
    fi

    # A Chase "Sale" transaction is equivalent to a purchase
    if ! [[ "$amtVal" =~ $costshare_chase__AMTDEC_REGEX ]]; then
      msg_fatal "amount field doesn't conform to regex.
 + purchase='$purchase'
 + purchaseCnt=$purchaseCnt'
 + costshare_chase__AMTDEC_REGEX=$costshare_chase__AMTDEC_REGEX"
    fi

    amtSign="${BASH_REMATCH[2]}"
    amt="${BASH_REMATCH[3]}"  # regex group lacks sign

    # A Sale's amount is negative while a refund is positive
    # purchase is considered a positive number while a refund
    # is negative therefore negate the "Sale"'s amount to
    # conform to the concept of a purchase 
    
    if ! [[ "$amtSign" == '-' ]]; then
      amt='-'$amt
    fi

    costshareCSVformat=''
    csv_field_append costshareCSVformat "$transDate" "$vendorName" "$amt" "$category"  
    echo "$costshareCSVformat"

  done
}
###############################################################################
##
##  Purpose
##    Identify purchase transactions that are included by various cost sharing
##    categories agreeded on by Party X and Party Y but excluded by the vendor
##    percentage table.  These might represent new vendors that should be added
##    to the vendor percentage table.  However, these purchase may, instead,
##    represent ones that aren't shared.  Therefore, they should be added to
##    the costshare_chase_purchases_excluded_tbl to avoid their present
##    or future consideration.
##    
##    The "report" displays the chase purchases without alteration, therefore,
##    if a purchase must be excluded, simply copy and paste it to the
##    costshare_chase_purchases_excluded_tbl.
##  In
##    STDIN  - Chase Credit Card CSV.
##  Out
##    STDOUT - Chase Credit Card CSV whose vendor/description is absent from
##             costshare__vendor_pct_tbl.
###############################################################################
costshare_chase__vendor_exclusion_report(){
  # forward all input to next step in pipeline but
  # report on anything that would be excluded.
  tee >( costshare_chase__vendor_newly_excluded >&2 )
}


costshare_chase__vendor_newly_excluded(){
  grep -v --fixed-string -f <(costshare_chase_purchases_excluded_tbl) \
  | grep -v --fixed-string -f <( costshare_chase__vendor_inclusion_filter_create)
}


costshare_chase__detect_error(){
  local -r -i parentProcID=$1

  local purchaseExclude
  if ! read -r purchaseExclude; then
    kill -s SIGUSR1 $parentProcID
    return;
  fi
  echo "$purchaseExclude"
  tee
  kill -s SIGUSR2 $parentProcID
}


costshare_chase__vendor_inclusion_filter_create(){
  costshare_vendor_pct_tbl   \
  | costshare__vendor_pct_tbl_normalize  \
  | costshare__vendor_name_stream
  echo DoesNotMatchAnyVendor 
}


costshare_chase__pileline_run(){

  set -o pipefail
  echo 'TransactionDate,VendorName,Charge,OffSpngPctShare,OffSpngShareAmt,ParentShareAmt,Category'
  grep -v  'Transaction Date,Post Date,Description,Category,Type,Amount,Memo'  \
  | grep --fixed-strings -f <( costshare_chase_category_filter_tbl ) \
  | costshare_chase__csv_expected  \
  | costshare_chase__vendor_exclusion_report \
  | costshare_charge_share_run
}

costshare_chase__error_report(){
  msg_fatal "at least one error or unaccounted for purchase was detected. view output of STDERR"
}

