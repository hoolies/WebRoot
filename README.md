# WebRoot
This WebRoot.ps1 connects to the WebRoot API by using your API username & password.
Then it POST the credentials of the global admin to create a tocken.
Then we set again the parameters to GET all the Site IDs & Names.
Finaly runs a loop with each Site ID and provides us all the endpoints that have an actice license.

This is created to run against the PSA/RMM database;
