#!/bin/bash

costshare_chase_purchases_exclude_specific_category_matches_tbl(){ 

cat<<'purchases_excluded'
02/22/2022,02/23/2022,WAL-MART #1970,Groceries,Sale,-4.08,
01/07/2022,01/09/2022,GULF OIL 92033926,Gas,Sale,-51.78,
12/21/2021,12/22/2021,MCDONALD'S F4857,Food & Drink,Sale,-4.80,
12/18/2021,12/20/2021,EXXONMOBIL    97442933,Gas,Sale,-46.18,
12/19/2021,12/20/2021,TST* FRANK PEPE S PIZZERI,Food & Drink,Sale,-29.69,
12/16/2021,12/17/2021,INTERSHELL SEAFOOD,Groceries,Sale,-306.00,
12/12/2021,12/13/2021,PIZZARELLA,Food & Drink,Sale,-30.92,
11/27/2021,11/29/2021,PANERA BREAD #202123 P,Food & Drink,Sale,-31.40,
11/28/2021,11/29/2021,GULF OIL 92033926,Gas,Sale,-15.19,
11/18/2021,11/21/2021,EXXONMOBIL    97442933,Gas,Sale,-65.32,
11/18/2021,11/19/2021,WHOLEFDS HGM 10159,Groceries,Sale,-43.19,
11/18/2021,11/19/2021,MCDONALD'S F1795,Food & Drink,Sale,-9.91,
10/28/2021,10/29/2021,WHOLEFDS HGM 10159,Groceries,Sale,-33.09,
10/23/2021,10/24/2021,TST* CHILL KITCHEN AND BA,Food & Drink,Sale,-59.22,
10/12/2021,10/13/2021,GULF OIL 92033926,Gas,Sale,-15.77,
09/10/2021,09/12/2021,KIMBALL FARM GRILL,Food & Drink,Sale,-66.23,
08/26/2021,08/29/2021,EXXONMOBIL    97442933,Gas,Sale,-51.28,
08/25/2021,08/27/2021,BERTUCCI'S - MARLBOROUGH,Food & Drink,Sale,-53.86,
08/17/2021,08/18/2021,GULF OIL 92033926,Gas,Sale,-15.43,
08/15/2021,08/16/2021,MCDONALD'S F1439,Food & Drink,Sale,-1.49,
08/10/2021,08/12/2021,EXXONMOBIL    97442933,Gas,Sale,-38.76,
08/10/2021,08/11/2021,PANERA BREAD #203555 K,Food & Drink,Sale,-44.36,
08/01/2021,08/02/2021,BERTUCCI'S-MARLBOROUGH O,Food & Drink,Sale,-26.81,
07/31/2021,08/01/2021,MCDONALD'S F4857,Food & Drink,Sale,-3.41,
07/28/2021,07/29/2021,MCDONALD'S F11668,Food & Drink,Sale,-6.12,
07/28/2021,07/29/2021,PANERA BREAD #203426 P,Food & Drink,Sale,-43.15,
07/23/2021,07/25/2021,EXXONMOBIL    97442933,Gas,Sale,-23.30,
07/08/2021,07/12/2021,REINS NY STYLE DELI,Food & Drink,Sale,-19.80,
07/09/2021,07/11/2021,STP&amp;SHPFUEL0489,Gas,Sale,-46.77,
07/08/2021,07/09/2021,LOUIES,Food & Drink,Sale,-67.89,
07/08/2021,07/09/2021,STP&amp;SHPFUEL0489,Gas,Sale,-21.91,
07/02/2021,07/04/2021,EXXONMOBIL    97442933,Gas,Sale,-38.33,
06/30/2021,07/01/2021,MCDONALD'S F7474,Food & Drink,Sale,-9.37,
06/30/2021,07/01/2021,STP&amp;SHPFUEL0489,Gas,Sale,-21.13,
06/26/2021,06/28/2021,BERTUCCI'S - MARLBOROUGH,Food & Drink,Sale,-21.18,
06/26/2021,06/28/2021,SUNOCO 0251907201,Gas,Sale,-39.06,
06/25/2021,06/27/2021,BURGER KING #5089,Food & Drink,Sale,-11.70,
06/25/2021,06/27/2021,PANERA BREAD #202129 P,Food & Drink,Sale,-13.78,
06/20/2021,06/23/2021,REINS NY STYLE DELI,Food & Drink,Sale,-31.33,
06/20/2021,06/22/2021,IHOP,Food & Drink,Sale,-49.90,
06/20/2021,06/21/2021,BP#6638126STRASGLOBAL,Gas,Sale,-25.00,
06/19/2021,06/21/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/19/2021,06/21/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/19/2021,06/21/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/20/2021,06/21/2021,TST* NANCY S AIR FIELD CA,Food & Drink,Sale,-31.88,
06/19/2021,06/21/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/20/2021,06/21/2021,MCDONALD'S F1834,Food & Drink,Sale,-6.40,
06/20/2021,06/21/2021,STP&amp;SHPFUEL0489,Gas,Sale,-37.26,
06/18/2021,06/20/2021,BERTUCCI'S - MARLBOROUGH,Food & Drink,Sale,-21.18,
06/19/2021,06/20/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/19/2021,06/20/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/18/2021,06/20/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.60,
06/19/2021,06/20/2021,BREAKING VENDING LLC,Food & Drink,Sale,-1.10,
06/17/2021,06/20/2021,SHELL OIL 57544283005,Gas,Sale,-45.40,
06/14/2021,06/16/2021,ROASTED PEPPERS,Food & Drink,Sale,-12.82,
06/13/2021,06/15/2021,EXXONMOBIL    97442933,Gas,Sale,-32.41,
06/12/2021,06/14/2021,EXXONMOBIL    97442933,Gas,Sale,-43.27,
06/11/2021,06/13/2021,STP&amp;SHPFUEL0489,Gas,Sale,-44.59,
06/06/2021,06/08/2021,EXXONMOBIL    97442933,Gas,Sale,-51.00,
06/04/2021,06/06/2021,PHILLIPS 66 - 421 GAS,Gas,Sale,-94.21,
06/02/2021,06/04/2021,EXXONMOBIL    97437743,Gas,Sale,-50.91,
05/29/2021,06/04/2021,UPTON TEA IMPORTS,Groceries,Sale,-111.00,
06/02/2021,06/03/2021,STP&amp;SHPFUEL0489,Gas,Sale,-31.94,
06/02/2021,06/03/2021,SQ *YIASOU YEEROS,Food & Drink,Sale,-19.44,
05/30/2021,05/31/2021,STP&amp;SHPFUEL0489,Gas,Sale,-26.20,
05/27/2021,05/28/2021,GULF OIL 92063782,Gas,Sale,-32.59,
05/21/2021,05/23/2021,GULF OIL 92033926,Gas,Sale,-15.60,
05/20/2021,05/21/2021,PIZZERIA REGINA MARLBORO,Food & Drink,Sale,-16.90,
05/18/2021,05/19/2021,DUNKIN #338096 Q35,Food & Drink,Sale,-35.47,
05/12/2021,05/14/2021,EXXONMOBIL    97442933,Gas,Sale,-46.95,
05/09/2021,05/11/2021,SHELL OIL 57544283005,Gas,Sale,-44.89,
05/07/2021,05/09/2021,STP&amp;SHPFUEL0489,Gas,Sale,-26.85,
05/05/2021,05/06/2021,WHOLEFDS HGM 10159,Groceries,Sale,-93.25,
05/01/2021,05/02/2021,MCDONALD'S F10096,Food & Drink,Sale,-18.99,
04/25/2021,04/26/2021,#2509-981D  ROASTED PE,Groceries,Sale,-11.69,
04/18/2021,04/20/2021,SHELL OIL 57544283005,Gas,Sale,-40.94,
04/18/2021,04/19/2021,SQ *MARBEN ROSE LLC,Food & Drink,Sale,-6.09,
04/09/2021,04/11/2021,EXXONMOBIL    97442933,Gas,Sale,-78.35,
04/06/2021,04/07/2021,PERKINS COVE LOBSTER SHA,Food & Drink,Sale,-59.68,
04/02/2021,04/04/2021,EXXONMOBIL    97457535,Gas,Sale,-59.61,
04/02/2021,04/04/2021,EXXONMOBIL    97442933,Gas,Sale,-36.39,
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
