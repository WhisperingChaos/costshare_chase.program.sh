# costshare_chase.program.sh
Creates a program using [costshare.source.sh](//github.com/WhisperingChaos/costshare.source.sh) to implement cost sharing for Chase Bank credit card purchases.

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
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L135-L171

Before calling this function, at least the [costshare_vendor_pct_tbl](#costshare_vendor_pct_tbl) callback must be overriden. 
[Table Contents](https://github.com/WhisperingChaos/costshare_chase.program.sh/blob/13a25c65b87de1e6b15206e483d9924a9d6f38f7/program/costshare_chase_program_sh/override/costshare_chase_category_filter_tbl.source.sh#L3-L9)

#### costshare_purchase_exclude_filter_tbl
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L83-L109

[How to override a callback function.](https://github.com/WhisperingChaos/SOLID_Bash#function-overriding)

##### Example
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L110-L126

#### costshare_vendor_pct_tbl
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L28-L72

[How to override a callback function.](https://github.com/WhisperingChaos/SOLID_Bash#function-overriding)

##### Example
https://github.com/WhisperingChaos/costshare.source.sh/blob/a50c24a0f5171d2cae5c8c78deb2b5482573e9f8/component/costshare.source.sh#L73-L82

### Install
#### Simple
Copy **costshare.source.sh** into a directory then use the Bash [source](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#Bash-Builtins) command to include this package in a the desired bash script before executing fuctions which rely on its [API](#api-index).  Copying using:

  * [```git clone```](https://help.github.com/articles/cloning-a-repository/) to copy entire project contents including its git repository.  Obtains current master which may include untested features.  To synchronize the working directory to reflect the desired release, use ```git checkout tags/<tag_name>```.
  *  [```wget https://github.com/whisperingchaos/costshare.source.sh/tarball/master```](https://github.com/whisperingchaos/costshare.source.sh/tarball/master) creates a tarball that includes only the project files without the git repository.  Obtains current master branch which may include untested features.
#### SOLID Composition
TODO
#### Developed Using 
GNU bash, version 4.3.48(1)-release

This component relies on [nameref/name reference feature](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) introduced in version 4.3.
### Test
After [installing](#install), change directory to **costshare.source.sh**'s ```test```. Then run:
  * ```./config.sh``` followed by
  * [**./costshare.source_test.sh**](test/costshare_source_test.sh).  It should complete successfully and not produce any messages.
```
host:~/Desktop/projects/costshare.source.sh/test$ ./costshare.source_test.sh
host:~/Desktop/projects/costshare.source.sh/test$ 
```
