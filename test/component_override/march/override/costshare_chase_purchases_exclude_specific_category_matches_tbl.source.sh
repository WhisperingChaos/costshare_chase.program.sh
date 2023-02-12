#!/bin/bash

costshare_chase_purchases_exclude_specific_category_matches_tbl(){ 

cat<<'purchases_excluded'
03/27/2021,03/28/2021,PANERA BREAD #203426 K,Food & Drink,Sale,-16.97,
03/25/2021,03/28/2021,EXXONMOBIL    97495402,Gas,Sale,-35.30,
03/26/2021,03/28/2021,DIWAN RESTAURANT,Food & Drink,Sale,-20.64,
03/22/2021,03/23/2021,HELENS RESTAURANT,Food & Drink,Sale,-68.41,
03/15/2021,03/17/2021,EXXONMOBIL    97442933,Gas,Sale,-29.43,
03/13/2021,03/14/2021,STP&amp;SHPFUEL0489,Gas,Sale,-30.09,
03/13/2021,03/14/2021,STP&amp;SHPFUEL0489,Gas,Sale,-42.59,
03/03/2021,03/05/2021,BURGER KING #3502  Q07,Food & Drink,Sale,-20.83,
03/03/2021,03/05/2021,EXXONMOBIL    98708092,Gas,Sale,-24.32,
02/28/2021,03/02/2021,EXXONMOBIL    99560534,Gas,Sale,-40.50,
02/28/2021,03/01/2021,RESTAURANT YAMAGUCHI,Food & Drink,Sale,-51.06,
purchases_excluded
# if the table above is empty then all transactions will match
# which then excludes all transactions. Therefore, create an
# an entry that won't exclude any valid transactions that should
# be excluded and will cause all transactions to flow through
# this filter when no purchases are excluded.
echo 'DoesNotMatchAnyPurchase'
}
