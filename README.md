versionatorr
============

Web app to compare maven and osgi version numbers using Google Appengine.

In action: [versionatorr.appspot.com](http://versionatorr.appspot.com)

Develop
-------

The actual web app code is in [versionatorr-war/src/main/webapp](versionatorr-war/src/main/webapp/).

### Run a local test server

    cd versionatorr-war
    mvn appengine:devserver
    
Then go to http://localhost:8080
    
Kill server with `CTRL+C`. Must be restarted every time a file has changed.

### Deploy to Google App engine

    cd versionatorr-war
    mvn appengine:update
    
If that fails with "Either the access code is invalid or the OAuth token is revoked.Details: invalid_grant", run

    rm ~/.appcfg_oauth2_tokens_java