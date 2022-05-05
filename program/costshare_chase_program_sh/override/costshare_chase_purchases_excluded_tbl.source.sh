#!/bin/bash

costshare_chase_purchases_excluded_tbl(){
# Note first column heading line is removed from this stream.
# Note the entry ",01/01/1900" is used to test the program.
# Since the rows below can include a limiting time component (transactionDateRegex)
# time bounded entries can remain in the table "forever".  Retaining
# these entries permits rerunning the program with historical data that should,
# if there have been no changes to the historical data sets, produce exactly 
# the same outcome.  However, peserving past time bounded entries will slow
# the program's performance when processing data sets whose purchases lie 
# outside bounded periods.  
cat <<'purchases_excluded_tbl'
<vendorNameRegex>,<transactionDateRegex>,<amtRegex>
,01/01/1900
purchases_excluded_tbl
}
