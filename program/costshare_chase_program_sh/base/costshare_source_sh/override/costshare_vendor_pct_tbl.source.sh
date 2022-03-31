#!/bin/bash

costshare_vendor_pct_tbl(){
  costshare_chase_vendor_pct_tbl \
  |  sed '1, 1d'
}


