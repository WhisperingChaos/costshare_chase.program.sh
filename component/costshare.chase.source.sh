#!/bin/bash
###############################################################################
##
##  costshare_chase
##
##  Purpose
##    Transform Chase Credit Card CSV format into the CSV format required by
##    the code that apportions credit card purchase between two parties.
##
##    Also, provide the ability to include/exclude Chase Credit Card 
##    purchases by the Chase assigned "Category" without propagating this
##    concept to the lower level calculation program.
##
##    This program represents a concrete version of 
##    See: https://github.com/WhisperingChaos/costshare.source.sh.  
##    
##  Note
##    Adheres to "SOLID bash" principles:
##    https://github.com/WhisperingChaos/SOLID_Bash#solid_bash
##
###############################################################################

############################## Hook/Callback Functions ########################
##
##  The function(s)s below define the callback "interface" for this component.
##  Override them to provide the input needed to drive this component's execution.
##  If unfamiliar with bash function override mechanism see:
##  https://github.com/WhisperingChaos/SOLID_Bash#function-overriding
##
###############################################################################

###############################################################################
##
##  This is the authoritative content which should be reflected by the
##  corresponding version found on the main branch:
##  https://github.com/WhisperingChaos/costshare.source.sh/blob/main/component/costshare.source.sh
##  Please update the referenced github description if the below differs.
##  
##  Purpose
##    Defines the vendor percentage table used to filter and calculate the
##    share amount of a purchase owed between two parties: Party 'X' and
##    Party 'Y'.
##    
##    Filtering selects only those purchases whose Vendor Names appear in
##    this table.  A "grep" "fixed string" comparision is performed between
##    each Vendor Name in this table and the one appearing in a purchase.  If
##    the fixed string comparison succeeds, the purchase is selected for 
##    further processing.  Note, fixed string evaluation compares all characters
##    according to their character values, therefore, a character's case
##    affects the comparison outcome and regular expressions are unsupported.
##  Why
##    Automates the process of filtering the purchases and calculating
##    what each party owes.
##  Format
##    Must conform to CSV format:
##
##     <Vendor Name>,<Party 'X' Percentage>
##
##     Must use double quotes to encapsulate Vendor Name when it contains
##     the CSV delimiter characters: double quotes or commas.
##     Whitespace can be used to visually align the column values.  Whitespace
##     will be eliminated from each side of a field value.  Also, repeated,
##     embedded whitespace will be replaced by a single "space" character.
##  Constraints
##    Vendor Name
##    - Must be capitalized in the same manner as specified by purchases.
##    - A partial vendor name can be specified.  However, it must be long
##      enough to uniquely assign the proper percentage that should be paid
##      by Party 'X'.  The algorithm selects the percentage 
##      associated to the longest matching vendor name before considering
##      shorter ones that share the same first whole word (root word).
##    - A root word must be at least 3 characters long.
##    - A vendor name will be truncated to 'costshare_VENDOR_NAME_LENGTH_MAX'
##      to prevent exploitation/bugs.
##    Party 'X' Percentage
##    - The percentage of the total charge to be paid by Party 'X'.
##    - The share paid by Party 'Y' is the amount that remains after deducting
##      the amount owed by Party 'X'.
##    - Must be a whole number that ranges: 0-100.
##
###############################################################################
costshare_chase_vendor_pct_tbl(){
  msg_fatal  "must override this table definition"
}
###############################################################################
##
##  This content is copied from:
##  https://github.com/WhisperingChaos/costshare.source.sh/blob/main/component/costshare.source.sh
##  for convienence.  It should always be the same.  Please replace the description
##  below with the authorative one from URL above if the below differs.
##
##  Purpose
##    Excludes purchases normally included by "costshare_vendor_pct_tbl".
##    Each CSV formatted row can define a regex pattern for each input field.
##  Why
##    There may be purchases involving a vendor that are typically shared
##    but in certain cases aren't.
##  Format
##    Must conform to CSV format:
##
##     [<Vendor Name>][,<Date>|,][,<Charge>] 
##
##    Vendor Name - (optional) extended regex.
##    Date        - (optional) extended regex.
##    Charge      - (optional) extended regex.
##
##    At least one of the above fields must be specified.
##    When combined, the regex of these fields identify the purchase(s)
##    to specifically exclude.
##
##    Omit a field from matching by either leaving it entirely empty or by 
##    specifing an empty value using a pair of double quotes ("").  If an
##    empty value is specified, a comma must terminate the field if a value
##    is specified for a subsequent field.
##
###############################################################################
costshare_chase_purchases_excluded_tbl(){
  msg_fatal  "must override this table definition"
}
###############################################################################
##
##  Purpose
##    Defines a table whose rows select purchases based on Chase Bank
##    Category descriptions which suggest they should be
##    included in cost sharing.  However, there will be purchases
##    assigned a cost sharing category that should instead be excluded.  
##    The matching semantics of a grep --fix-string match is 
##    performed using the contents of this table on the Chase Bank
##    credit card CSV input stream.
## Why
##    Helps to eliminate calculation errors by including only those purchases
##    likely to be shared while excluding ones that should never be considered.
##    Also, it performs this search on the Chase CSV formatted purchases and
##    this format's semantics before these purchases are conveted to a different
##    format whose semantics are devoid of the category concept.
##  Format
##    Must conform to:
##
##     ,<Category>, 
##
##    Category - (required) any Chase Bank descriptive category extracted from
##               their CSV stream fed into this program.  The leading and trailing
##               commas better ensure match semantics will only consider the 
##               contents of the category field in the CSV stream, as hopefully,
##               a category description/name doesn't match the full name of a 
##               purchase vendor/description field.
###############################################################################
costshare_chase_category_filter_tbl(){
  msg_fatal  "must override this table definition"
}
###############################################################################
##
##  Purpose
##    Define a table to exclude specific purchases that are incorrectly included
##    in cost sharing when applying the Chase Bank category table rows.  
##    The matching semantics of a grep --fix-string match are performed using 
##    the contents of this table on the Chase Bank credit card CSV input stream.
## Why
##    Helps to eliminate cost sharing errors by excluding only those purchases
##    that should never be considered.
##    Also, it performs this search on the Chase CSV formatted purchases and
##    their semantics before these purchases are conveted to a different
##    format whose semantics are devoid of the category concept.
##  Format
## 
##     <Transaction Date>,<Post Date>,<Description>,<Category>,<Type>,<Amount>,<Memo>
##
##    A row in the table must contain the minimal portion of a Chase Bank CSV
##    purchase entry that matches the purchase(s) that must be excluded
##    without affecting any purchase that must be included. The easiest method
##    is to add a row in the table that exactly matches the corresponding entry
##    in the Chase Bank input stream.  This ensures that this row will only
##    affect that specific entry in the input stream.  
###############################################################################
costshare_chase_purchases_exclude_specific_category_matches_tbl(){
  msg_fatal  "must override this table definition"
}
############################ private implementation ###########################
#
#   The code below shouldn't change unless there's a bug.
#
###############################################################################

###############################################################################
##
##  Purpose
##    Execute the entire pipeline Chase CSV transform and reporting pipeline.
##  Why
##    Encapsulates the entire pipeline in a function allowing for the detection
##    of lower level errors, whose return values are potentially masked
##    by the use of bash process substitution.
##  In/Out:
##    See: "costshare_chase__executable_help()"
##
###############################################################################
costshare_chase__executable_run(){
  local -r composeExecFilePath="$1"

  local overrideComponentDir
  local rtnCnd
  shift 1
  if ! costshare_chase__executable_opts overrideComponentDir rtnCnd "$@"; then
    return $rtnCnd
  fi

  costshare_chase__executable_override "$composeExecFilePath" "$overrideComponentDir"

  trap "exit 0"                                SIGUSR1
  trap "costshare_chase__error_report; exit 1" SIGUSR2
  costshare_chase__pileline_run  2> >( costshare_chase__detect_error $$  >&2 )
  while sleep 1; do
    : # let error detector signal done 
  done
}

costshare_chase__executable_opts(){
  local -n overrideComponentDirRTN=$1
  local -n rtnCndRTN=$2

  shift 2
  while [[ $# -gt 0 ]]; do

    if [[ "$1" == '-h' ]] \
    || [[ "$1" == '--help' ]] \
    || [[ $# -ne 1 ]]; then
      costshare_chase__executable_help
      rtnCndRTN=0
      return 1
    fi

    overrideComponentDirRTN="$1"
    shift 1
  done

  if ! [[ -d "$overrideComponentDirRTN" ]]; then 
    msg_fatal "Specified component override directory not found. overrideComponentDirRTN='$overrideComponentDirRTN'"
  fi
}


costshare_chase__executable_help(){
cat <<HELPDOC

Usage: ChaseCCcsv | costshare_chase.program.sh [Option] OverrideComponentDir

Filter Chase Credit Card transactions then compute amount owed between
two parties which agreed to share the cost.

Option:
    -h,--help     Display this help text and exit.

Argument:

OverrideComponentDir:
    Interface functions detailed in the source code comments of 
    costshare_chase.source.sh must be overriden to specify certain
    filtering features that select or exclude credit card
    transactions as well as defining the percentage to be paid by
    one party for specific vendor charges appearing in the credit
    card description field.  You must read these comments and provide
    function bodies that provide the data in the required format.

    When defining these interface functions, create one or more
    bash source files adhering to the following naming convention:
    <namespace>'.source.sh' where <namespace> can be nearly any
    name, however, suggest using "costshare_chase".  Save this file
    to a subdirectory named "override" in any parent directory
    except the one containing this program.  Finally, when running
    this program, specify the name of the parent directory as the
    value of this argument.   
    
Input:

STDIN: ChaseCCcsv -
  Downloaded Chase Credit Card transactions formatted as Comma
  Separated Values (CSV).  Logon to Chase then use the search transaction
  feature to select the desired transaction period.  Once selected,
  export them in CSV format which downloads them to the current
  connected device.

  This CSV format should adhere to (as of 02/28/2022):

  <Transaction Date>,<Post Date>,<Description>,<Category>,<Type>,<Amount>[,forwardedFields]

  Transaction Date
              - MM/DD/YYYY. The purchase date.
  Post Date   - MM/DD/YYYY. The date the purchase was applied to the credit card account.
  Description - A string of characters that describes the purchased item.  The description
                contains the name of the vendor (company) that sold the item.  It
                also usually describes the item's type/product name.
  Category    - A value generated by Chase that groups similar items.
  Type        - A value specified by Chase that classifies the transaction as either a
                "Sale", "Return", "Payment", or perhaps others.  This program only considers
                "Sale" and "Return" transaction types
  ,forwardedFields
              - (optional) Additional data, not necessarily in CSV format, that's preserved
                and will appear in the generated output.  This additional data can, for
                instance, contain a unique id.  This unique id can be used to definitively
                correlate the generated output to this process' input.       
 
Output:

STDOUT - newline delimited CSV records with format:

  <Transaction Date>,<Vendor Name>,<Charge>,<PartyXpct>,<SharePartyXRound>,<SharePartyY>,Category,Type[,forwardedFields]

  Transaction Date
              - MM/DD/YYYY. The purchase date.
  Vendor Name - A.K.A Description. Vendor can contain
                any character value. It will also be normalized:
                whitespace appearing before the first non-whitespace
                character and those appearing after the last
                non-whitespace character are removed.  Also,
                repeating whitespace embedded inside a name are
                replaced by a single "space" character.
  Charge      - Will either be a whole number or a
                decimal number with 2 places of accuracy to right
                of decimal point.  It can be prefix by a sign(+-).
  PartyXpct   - Party 'X' percentage applied to the charge
  SharePartyXRound
              - Calculated Party 'X' portion of the charge
                rounded using "unbaised/bankers" rounding method.
  SharePartyY - Calculated Party 'Y' portion of the charge.  Party
                'Y''s portion represents the remainder of the charge
                afer subtracting the total transaction charge by
                the portion owed by Party 'X'.
  ,forwardedFields
              - See STDIN.

HELPDOC
}

costshare_chase__executable_override(){
  local -r absExecFilePath="$( readlink -f "$1")"
  local -r absOverrideDir="$( readlink -f "$2" )"

  local -r absExecDir="$( dirname "$absExecFilePath" )"
  local -r callSourcer="$absExecDir"'/config_sh/vendor/sourcer/sourcer.sh'
  local component
  for component in $( "$callSourcer" "$absOverrideDir"); do
    source "$component"
  done
}

###############################################################################
##
##  Purpose
##    Execute the Chase CSV transform and reporting pipeline.
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
  echo 'TransactionDate,VendorName,Charge,PartyXpct,SharePartyXRound,SharePartyY,Category,Type'
  grep -v  'Transaction Date,Post Date,Description,Category,Type,Amount,Memo'  \
  | grep    --fixed-strings -f <( costshare_chase_category_filter_tbl ) \
  | grep -v --fixed-strings -f <( costshare_chase_purchases_exclude_specific_category_matches_tbl ) \
  | costshare_chase__vendor_exclusion_report  \
  | costshare_chase__csv_transform  \
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
costshare_chase__csv_transform(){

   local purchase
   local -i purchaseCnt=0
   local transDate
   local fieldIgnore
   local vendorName
   local category
   local transType
   local amtVal
   local $csv_field_REMAINDER
   local forwardedFields
   local costshareCSVformat

   while read -r purchase; do
    (( purchaseCnt++ ))

    if ! csv_field_get_unset_as_empty "$purchase" transDate fieldIgnore vendorName category transType amtVal csv_field_REMAINDER 2>/dev/null; then
      msg_fatal "problem reading Chase CSV purchase='$purchase' purchaseCnt=$purchaseCnt"
    fi

    if [[ -z "$vendorName" ]] \
    || [[ -z "$amtVal" ]]     \
    || [[ -z "$transDate" ]]  \
    || [[ -z "$transType" ]]; then
      msg_fatal "missing required field set to null string. purchase='$purchase' purchaseCnt=$purchaseCnt'"
    fi
    
    if [[ "$transType" != "Sale" ]] \
    && [[ "$transType" != "Return" ]]; then
      continue
    fi
 
    costshareCSVformat=''
    csv_field_append costshareCSVformat "$transDate" "$vendorName" "$amtVal" "$category" "$transType"
    if ! [[ -z "${!csv_field_REMAINDER}" ]]; then
	costshareCSVformat="${costshareCSVformat},${!csv_field_REMAINDER}"
    fi
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

  grep -v --fixed-strings -f <( costshare_chase_purchases_exclude_specific_category_matches_tbl ) \
  | costshare_purchase_vendor_csv_filter 3 -v
}

costshare_chase__vendor_inclusion_filter_create(){
  costshare_vendor_pct_tbl   \
  | costshare__vendor_pct_tbl_normalize  \
  | costshare__vendor_name_stream
  echo DoesNotMatchAnyVendor 
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

costshare_chase__error_report(){
  msg_fatal "at least one error or unaccounted for purchase was detected. view output of STDERR"
}
