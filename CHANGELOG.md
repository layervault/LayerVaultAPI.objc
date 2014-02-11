# LayerVaultAPI CHANGELOG

## 1.1.0
- Only refresh credential when we get 401 AND the credential is expired.
- Added `syncType` property to `LVCOrganization`. 

## 1.0.0

- Added `LVCOAuthCredentialStorage` to give more flexibility with OAuth Credentials.
- Removed automatic saving to the keychain in LVCAuthenticatedClient.
- Many `LVCHTTPClientMethods` that take a path must now be percent encoded. See method doc for more info.
- Added `NSString+PercentEncoding` to force percent encoding on reserved characters. Useful for filenames that may contain these reserved characters.
- Added `userID` property to LVCUser.
- Added `percentEncodedURLPath` property to `LVCNode` and `LVCFileRevision`.
- Exposed `NSString *mimeForFile(NSURL *fileURL)` in `LVCAmazonS3Client`.
- Fixed issue where refreshing a token during `/me` would never execute completion.
- Calling `- getMeWithCompletion:` will always update the `user` property in `LVCAuthenticatedClient`.
- Added `+ colorLabelForName:` to `LVCColorUtils`.
- Fixed a crash with the demo application when the first organization doesn’t have and projects.
- Fixed some compiler warning with `LVCMockResponses`.


## 0.2.0

- Added `LVCAutenticatedClient` to abstract out:
	- Handling Refresh Tokens
	- Keychain Support
	- Getting the Logged In User
- Exposed `defaultBaseURL` in `LVCHTTPClient`
- Fixed some non-passing tests

## 0.1.0

Initial release.
