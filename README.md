![example event parameter](https://github.com/WhisperingChaos/costshare_chase.program.sh/actions/workflows/main.yml/badge.svg?event=push)

# costshare_chase.program.sh
A program that implements cost sharing for Chase Bank credit card purchases.

## ToC
[API Index](#api-index)  
[API](#api)  
[Install](#install)  
[Test](#test)
[Run](#run)  
[License MIT](LICENSE)  


### API Index

[costshare_chase_category_filter_tbl](#costshare_chase_category_filter_tbl)

[costshare_chase_purchases_exclude_specific_category_matches_tbl](#costshare_chase_purchases_exclude_specific_category_matches_tbl)

[costshare_chase_purchases_excluded_tbl](#costshare_chase_purchases_excluded_tbl)

[costshare_chase_vendor_pct_tbl](#costshare_chase_vendor_pct_tbl)


### API
#### costshare_chase_category_filter_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/c9595b2f2796746d804c935a909d5666ad37c81f/component/costshare.chase.source.sh#L120-L147

This table must contain at least one category entry.  It must exist in the "override" directory specified as an argument to this program.
##### Example
[Table Contents](test/component_override/TableSamples/costshare_chase_category_filter_tbl.source.sh)

#### costshare_chase_purchases_exclude_specific_category_matches_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/c9595b2f2796746d804c935a909d5666ad37c81f/component/costshare.chase.source.sh#L151-L174

This table may be empty.  It must exist in the "override" directory specified as an argument to this program.  ##### Example
Not Available

#### costshare_chase_purchases_excluded_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/c9595b2f2796746d804c935a909d5666ad37c81f/component/costshare.chase.source.sh#L85-L116

This table may be empty.  It must exist in the "override" directory specified as an argument to this program.  
##### Example
[Table Contents](test/component_override/TableSamples/costshare_chase_purchases_exclude_specific_category_matches_tbl.source.sh).

#### costshare_chase_vendor_pct_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/c9595b2f2796746d804c935a909d5666ad37c81f/component/costshare.chase.source.sh#L32-L81 

##### Example
[Table Contents](https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/main/test/component_override/TableSamples/costshare_chase_vendor_pct_tbl.source.sh)

### Install
  * [```git clone```](https://help.github.com/articles/cloning-a-repository/) to copy entire project contents including its git repository.  Obtains current master which may include untested features.  To synchronize the working directory to reflect the desired release, use ```git checkout tags/<tag_name>```.
  *  [```wget https://github.com/whisperingchaos/costshare.source.sh/tarball/master```](https://github.com/whisperingchaos/costshare.source.sh/tarball/master) creates a tarball that includes only the project files without the git repository.  Obtains current master branch which may include untested features.
  *  Since this program is composed from a number of components, it must be "configured" in order to download it's dependencies.
  ```
  > cd program
  > ./config.sh
  ```
  Once the above successfully finishes, all the program's static dependencies have been downloaded and installed to the proper subdirectories in "program/costshare_chase_program_sh".
#### SOLID Composition
TODO

[How to override a callback function.](https://github.com/WhisperingChaos/SOLID_Bash#function-overriding)
#### Depends on 
  - GNU bash, version 4.3.48(1)-release. This component relies on [nameref/name reference feature](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) introduced in version 4.3.
  - The Bash components listed in its [vendor.config](program/config_sh/vendor/vendor.config)

### Test
After [installing](#install), change directory to **costshare_chase.program.sh**'s ```test```. Then run:
  * ```>./config.sh``` followed by
  * [**./test_costshare_chase.program.sh**](test/test_costshare_chase.program.sh).  It should complete successfully and not produce any messages.
```
> ~/Desktop/projects/test_costshare_chase.program.sh/test$ ./costshare.source_test.sh
> ~/Desktop/projects/test_costshare_chase.program.sh/test$ 
```
### Run
```
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

```
> cd program 
> cat MarchCreditCardSatement.cvs | ./costshare_chase.program.sh ./
