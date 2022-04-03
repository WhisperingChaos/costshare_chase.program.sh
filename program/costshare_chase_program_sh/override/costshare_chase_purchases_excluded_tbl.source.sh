#!/bin/bash

costshare_chase_purchases_excluded_tbl(){
# nothing to exclude so far.  Note first line is removed from stream
cat <<'purchases_excluded_tbl'
<vendorNameRegex>,<dateRegex>,<amtRegex>
purchases_excluded_tbl
}
