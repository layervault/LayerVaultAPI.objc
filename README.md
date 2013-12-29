# LayerVaultAPI [![License](https://go-shields.herokuapp.com/license-MIT-blue.png)](LICENSE)

[![Version](https://cocoapod-badges.herokuapp.com/v/LayerVaultAPI/badge.png)](http://cocoadocs.org/docsets/LayerVaultAPI)
[![Platform](https://cocoapod-badges.herokuapp.com/p/LayerVaultAPI/badge.png)](http://cocoadocs.org/docsets/LayerVaultAPI)

## Usage

### Authenticating
`LVCHTTPClient` is the main interface to the LayerVault API and is based on [AFOAuth2Client](https://github.com/AFNetworking/AFOAuth2Client) for authentication. You can save an `AFOAuthCredential` to the keychain so you do not need to save the username or password.
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

        // Set Authorization Header
        [client setAuthorizationHeaderWithCredential:credential];
	} 
}];
```

### Getting User Information
`LVCUser` contains all the information for a user including the organizations they are a part of and the projects they have access to. `LVCHTTPClient` can get your user information like so:
``` objc
[client getMeWithCompletion:^(LVCUser *user,
                              NSError *error,
                              AFHTTPRequestOperation *operation) {
   NSLog(@"%@’s Projects: %@", user.firstName, user.projects);
}];
```

### Getting Project Information
`LVCProject` contains all the information for a project all the folders, files, and revisions. `LVCHTTPClient` can get your user information like so:
``` objc
[client getProjectWithName:@"My Awesome App"
     organizationPermalink:@"fancy-company"
                completion:^(LVCProject *project,
                             NSError *error,
                             AFHTTPRequestOperation *operation) {
    NSLog(@"Look at my files: %@", project.files);
}];

```

### Uploading an Image
This is how you would upload an image:
``` objc
NSURL *fileURL = [NSURL fileURLWithPath:@"/Users/alex/Desktop/hi.jpg"];
[client uploadLocalFile:fileURL
                 toPath:@"fancy-company/My Awesome App"
             completion:^(LVCFile *file,
                          NSError *error,
                          AFHTTPRequestOperation *operation) {
	if (file) {
		NSLog(@"file uploaded successfully: %@", file);
	}
}];

```


## Requirements

- [Xcode 5](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
- [CocoaPods](http://cocoapods.org)
- [AFNetworking 1.3.3](http://afnetworking.com)
- [AFOAuth2Client 0.1.1](https://github.com/AFNetworking/AFOAuth2Client)
- [Mantle 1.3](https://github.com/MantleFramework/Mantle)

## Installation

LayerVaultAPI is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "LayerVaultAPI"

## Author

Matt Thomas, matt@codecaffeine.com

## License

LayerVaultAPI is available under the MIT license. See the LICENSE file for more info.

