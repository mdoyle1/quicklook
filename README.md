# quicklook (Jamf Cloud Server)![quicklook logo](logo.png "quicklook logo")

_a quicklook into your Jamf inventory_
[_Available in the Apple Store for iOS Devices!_](https://apps.apple.com/us/app/quicklook-jcs/id1513229388)

- [About](#About)
- [Login View](#loginview)
- [Scripts](#scripts)
- [Computers](#computers)
- [Devices](#devices)
- [Policies](#policies)
- [iOS Configurations](#iosconfigurations)
- [macOS Configurations](#macOSconfigurations)
- [Going Forward](#goingforward)

## [About:](#About)

Quicklook is my first iOS app.  It's designed to give Jamf Admins and auditors a quick look at the most commonly accessed Jamf Pro data and functions. Quicklook is designed, built, and maintained outside of Jamf as a side project to expand my programming skills. It is not affiliated with Jamf, it is not officially maintained by Jamf.


## [Login View:](#loginview)

Enter your Jamf Pro url, username and password.
This information is stored in the apps defaults for future logins. 
It can also be cleared by hitting “Clear All?”

## [Scripts:](#scripts)

Access and view all the scripts in your Jamf Pro instance.
* Share JAMF scripts via messages, email or where ever!
* Delete scripts by swiping left


## [Computers:](#computers)

Here you can search for a computers by name, mac address, asset tag, etc.
The search field uses the same format as the general search in Jamf. 
* Search for specific computers in your Jamf Pro instance
* Share a computer details with anyone via email, text or app of choice.
* Run JAMF Commands on specific computers

A computer search returns a list of computers and displays navigation links containing the computers name, serial, asset tag and assigned user. Pressing a link will display a detail view showing the selected computers IP, Mac address and much more.  You also have the ability to share this information with other members of your organization.

## [Devices:](#devices)
***Same as computers***
* Search for specific devices in your Jamf Pro instance
* Share a device details with anyone via email, text or app of choice.
* Run JAMF Commands on specific devices

## [Policies:](#policies)

Displays a list of navigation links to your Jamf Pro policies. Upon selecting a policy you can view the following contents, policy name, execution frequency, id, enabled, scope, packages, scripts or other processes assigned to the policy.  You can also toggle the policy on and off by pressing the Enabled button.  The button will reflect whether or not the policy is enabled with a Bool. You also have the ability to delete policies by swiping left or by pressing edit on the top right and selecting an array of policies to delete.

* View policy details
* Toggle a policy on and off
* Delete a policy or select and delete multiple policies

**Note:** *Upon initially setting this portion of the app up I noticed there were a ton of policies being displayed that were not visible in the Jamf UI.  I believe these policies are created by Jamf Remote. I went ahead and deleted them after taking a crash course on semaphores.*

## [iOS Configurations:](#iosconfigurations)
* View all configuration profiles and payloads
*  View scope, limitations and exclusions

## [macOS Configurations:](#macosconfigurations)
* View macOS available configuration profiles
* View scope, limitations and exclusions

## [Going Forward:](#goingforward)
My goal for this app is quick access to Jamf functions.
Look for the following coming soon…
- Create and edit policies on the fly
- Greater detail about each computer, applications and logs
- WatchOS support, once I get a watch, just so I can reboot a device using my watch...

> Written with [StackEdit](https://stackedit.io/).
