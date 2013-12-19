# LayerVaultAPI

[![Version](http://cocoapod-badges.herokuapp.com/v/LayerVaultAPI/badge.png)](http://cocoadocs.org/docsets/LayerVaultAPI)
[![Platform](http://cocoapod-badges.herokuapp.com/p/LayerVaultAPI/badge.png)](http://cocoadocs.org/docsets/LayerVaultAPI)

## Usage

### LVCHTTPClient
`LVCHTTPClient` is the main interface to the LayerVault API and is based on [AFOAuth2Client](https://github.com/AFNetworking/AFOAuth2Client).

##### Example Authentication via Username & Password
`AFOAuth2Client` uses `AFOAuthCredential` for authentication. This means you do not need to save the username or password, but rather the AFOAuthCredential returned.
``` objc
LVCHTTPClient *client = [[LVCHTTPClient alloc] initWithClientID:@"CLIENT_ID" 
													     secret:@"CLIENT_SECRET"];

// Authenticate with a username & password
[client authenticateWithEmail:self.emailField.stringValue
                     password:self.passwordField.stringValue
                   completion:^(AFOAuthCredential *credential,
                                NSError *error) {
	if (credential) {
		// Save Credential to Keychain
		[AFOAuthCredential storeCredential:credential
                    withIdentifier:client.serviceProviderIdentifier];
	} 
	else {
	    // Report Error
	}
}];
````

##### Example Retrieving & Checking a Saved AFOAuthCredential
LayerVault API service expires an OAuth2 token after 2 hours. Luckily, the OAuth credential also contains a refresh token which can be used to fetch a new OAuth credential without requiring a username/password.
``` objc
// Retrieving
AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:client.serviceProviderIdentifier];

// Checking for Expiration
if (credential.expired) {
    [client authenticateUsingOAuthWithPath:@"/oauth/token"
                              refreshToken:credential.refreshToken
                                   success:^(AFOAuthCredential *refreshedCredential) {
                                       // Save New Credential to Keychain
		                               [AFOAuthCredential storeCredential:credential
                                                           withIdentifier:client.serviceProviderIdentifier]
                                   }
                                   failure:^(NSError *error) {
                                       // Report Error
                                   }];
}
```

##### Example Setting the Authorization Header
Once you have a valid and non-expired AFOAuthCredential, you can set your client’s authorization header with it and you are ready to go.
``` objc
[client setAuthorizationHeaderWithCredential:credential];
```

### LVCUser
`LVCUser` contains all the information for a user. `LVCHTTPClient` can get your user information like so:
``` objc
client getMeWithCompletion:^(LVCUser *user,
                           NSError *error,
                           AFHTTPRequestOperation *operation) {
    if (user) {
        // Do something with the user
    }
    else {
        // Report Error
    }
}];
```


## Requirements

- Xcode 5
- CocoaPods

## Installation

LayerVaultAPI is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "LayerVaultAPI"

## Author

Matt Thomas, matt@codecaffeine.com

## License

LayerVaultAPI is available under the MIT license. See the LICENSE file for more info.

