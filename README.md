# LayerVaultAPI [![License](https://go-shields.herokuapp.com/license-MIT-blue.png)](LICENSE)

[![Version](https://cocoapod-badges.herokuapp.com/v/LayerVaultAPI/badge.png)](http://cocoadocs.org/docsets/LayerVaultAPI)
[![Platform](https://cocoapod-badges.herokuapp.com/p/LayerVaultAPI/badge.png)](http://cocoadocs.org/docsets/LayerVaultAPI)

## Usage

### Authenticating
`LVCAuthenticatedClient` is the main interface to the LayerVault API and is based on [AFOAuth2Client](https://github.com/AFNetworking/AFOAuth2Client) for authentication. You can save an `AFOAuthCredential` to the keychain so you do not need to save the username or password.

``` objc
LVCAuthenticatedClient *client = [[LVCAuthenticatedClient alloc] initWithClientID:LVClientID
                                                                           secret:LVClientSecret];
// Authenticate with a username & password
[self.client loginWithEmail:userName password:password];
```

The authentication state can be observed. Because OAuth tokens expire, users will need to be re-authenticated

``` objc
[self.client addObserver:self
              forKeyPath:@"authenticationState"
                 options:NSKeyValueObservingOptionNew
                 context:kMyContext];
```

``` objc
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kMyContext) {
        if ([keyPath isEqualToString:@"authenticationState"]) {
            LVCAuthenticationState authenticationState = (LVCAuthenticationState)[change[@"new"] integerValue];
            if (authenticationState == LVCAuthenticationStateTokenExpired) {
                [self.client loginWithEmail:self.email password:self.password];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
```

### Getting User Information
`LVCUser` contains all the information for a user including the organizations they are a part of and the projects they have access to. `LVCAuthenticatedClient` has a user property that is set automatically when authentication completes:
``` objc
NSLog(@"%@’s Projects: %@", client.user.firstName, client.user.projects);
```

### Getting Project Information
`LVCProject` contains all the information for a project all the folders, files, and revisions. `LVCAuthenticatedClient` can get your user information like so:
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

