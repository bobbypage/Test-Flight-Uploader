#Test-Flight-Uploader

Test-Flight-Uploader lets you upload your app to the testflight servers using a mac app. 

##Background
Test-Flight is "free OTA Beta distribution of your iOS Apps"

i.e: you upload your app (adhoc build) and you can let testers easily use test your app
The benefit is that it's very simple for you to recruit testers and it's simple for tester to install your app (no iTunes involved because its OTA)

Though, you can do the same on the testflight website, this application is useful for uploading larger beta (ipa) files as it usually allows for a more stable connection then your browser.

##To use the app:
1. `git clone` or download the repository
2. Compile the project in Xcode
3. Copy and paste the [api-token](https://testflightapp.com/account/) and [team-token-key](https://testflightapp.com/dashboard/team/edit/) from the testflight website
4. Select your IPA
5. Press Upload
6. ????
7. Profit!!

This app is powered by the [Test-Flight API](https://testflightapp.com/api/doc/). 