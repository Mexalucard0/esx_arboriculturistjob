# fxserver-esx_arboriculturistjob
FXServer ESX Arboriculturist Job

-----------------------------------------
-- Created and modify by Slewog and Plumes_YT
-----------------------------------------

	* Player management (billing and boss actions)
	* esx_society => https://github.com/FXServer-ESX/fxserver-esx_society
	* esx_billing => https://github.com/FXServer-ESX/fxserver-esx_billing

[INSTALLATION]

1) CD in your resources/[esx] folder
2) Copy the repository
3) Import fr_esx_arboriculturistjob.sql OR en_esx_arboriculturistjob.sql in your database (not the both)

4) Add this in your server.cfg :

```
start esx_arboriculturistjob
```

5) If you want player management you have to set Config.EnablePlayerManagement on true in config.lua