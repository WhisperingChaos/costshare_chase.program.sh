#!/bin/bash

costshare_chase_purchases_exclude_specific_category_matches_tbl(){ 
# if the table above is empty then all transactions will match
# which then excludes all transactions. Therefore, create an
# an entry that won't exclude any valid transactions that should
# be excluded and will cause all transactions to flow through
# this filter when no purchases are excluded.
echo 'DoesNotMatchAnyPurchase'
}
