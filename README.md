![example event parameter](https://github.com/github/docs/actions/workflows/main.yml/badge.svg?event=push)

# costshare_chase.program.sh
Creates a program using to implement cost sharing for Chase Bank credit card purchases.

## ToC
[API Index](#api-index)  
[API](#api)  
[Install](#install)  
[Test](#test)  
[License MIT](LICENSE)  


### API Index

[costshare_chase_category_filter_tbl](#costshare_chase_category_filter_tbl)

[costshare_chase_purchases_exclude_specific_category_matches_tbl](#costshare_chase_purchases_exclude_specific_category_matches_tbl)

[costshare_chase_purchases_excluded_tbl](#costshare_chase_purchases_excluded_tbl)

[costshare_chase_vendor_pct_tbl](#costshare_chase_vendor_pct_tbl)


### API
#### costshare_chase_category_filter_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/bbcb9a452473c204aff1a3722da4193da0e8a6a0/program/costshare.chase.program.sh#L114-L141

This table must contain at least one category entry.  It exists in [program/costshare_chase_program_sh/override/](program/costshare_chase_program_sh/override/)
[table contents](program/costshare_chase_program_sh/override/costshare_chase_category_filter_tbl)

Before calling this function, at least the [costshare_vendor_pct_tbl](#costshare_vendor_pct_tbl) callback must be overriden. 
[Table Contents](https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/13a25c65b87de1e6b15206e483d9924a9d6f38f7/program/costshare_chase_program_sh/override/costshare_chase_category_filter_tbl.source.sh#L3-L9)

#### costshare_chase_purchases_exclude_specific_category_matches_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/bbcb9a452473c204aff1a3722da4193da0e8a6a0/program/costshare.chase.program.sh#L145-L168


#### costshare_chase_purchases_excluded_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/bbcb9a452473c204aff1a3722da4193da0e8a6a0/program/costshare.chase.program.sh#L79-L110

[How to override a callback function.](https://github.com/WhisperingChaos/SOLID_Bash#function-overriding)

##### Example
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L110-L126

#### costshare_chase_vendor_pct_tbl
https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/bbcb9a452473c204aff1a3722da4193da0e8a6a0/program/costshare.chase.program.sh#L26-L75

[How to override a callback function.](https://github.com/WhisperingChaos/SOLID_Bash#function-overriding)

##### Example
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L73-L82

### Install
  * [```git clone```](https://help.github.com/articles/cloning-a-repository/) to copy entire project contents including its git repository.  Obtains current master which may include untested features.  To synchronize the working directory to reflect the desired release, use ```git checkout tags/<tag_name>```.
  *  [```wget https://github.com/whisperingchaos/costshare.source.sh/tarball/master```](https://github.com/whisperingchaos/costshare.source.sh/tarball/master) creates a tarball that includes only the project files without the git repository.  Obtains current master branch which may include untested features.
  *  Since this program is composed from a number of components, it must be "configured" in order to download it's dependencies.
  ```
  > cd program
  > ./config.sh
  ```
  Once the above successfully finishes, all the program's static dependencies have been downloaded and installed to the proper subdirectories in "costshare_chase_program_sh".
#### SOLID Composition
TODO
#### Depends on 
  - GNU bash, version 4.3.48(1)-release. This component relies on [nameref/name reference feature](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) introduced in version 4.3.
  - The Bash components listed in its [vendor.config](program/config_sh/vendor/vendor.config)

### Test
After [installing](#install), change directory to **costshare_chase.program.sh**'s ```test```. Then run:
  * ```>./config.sh``` followed by
  * [**./test_costshare_chase.program.sh**](test/test_costshare_chase.program.sh).  It should complete successfully and not produce any messages.
```
>~/Desktop/projects/test_costshare_chase.program.sh/test$ ./costshare.source_test.sh
>~/Desktop/projects/test_costshare_chase.program.sh/test$ 
```
