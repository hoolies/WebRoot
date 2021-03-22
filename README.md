# WebRoot
This WebRoot.ps1 connects to the WebRoot API by using your API username & password.
Then it POST the credentials of the global admin to create a tocken.
Then we set again the parameters to GET all the Site IDs & Names.
Finaly runs a loop with each Site ID and provides us all the endpoints that have an actice license.

This is created to run against the PSA/RMM database;

Original script was created by Robbie Vance:
http://pleasework.robbievance.net/howto-get-webroot-endpoints-using-unity-rest-api-and-powershell/

The original script run for only one Site ID.
I am using the Parent KeyCode and I run it for all Site IDs
