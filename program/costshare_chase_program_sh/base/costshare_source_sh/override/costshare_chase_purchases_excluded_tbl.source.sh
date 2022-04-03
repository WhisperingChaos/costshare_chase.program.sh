#!/bin/bash

costshare_purchase_exclude_filter_tbl(){
  costshare_chase_purchases_excluded_tbl \
  |  sed '1, 1d'
}


