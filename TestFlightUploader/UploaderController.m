//
//  UploaderController.m
//  TestFlightUploader
//
//  Created by David Porter on 5/13/11.
//  Copyright 2011 David Porter Apps. All rights reserved.
//

#import "UploaderController.h"
#import "JSON.h"
@implementation UploaderController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (BOOL)fieldsFilled {
    if ([[api_token_field stringValue] isEqualToString:@""]) {
        return  NO;
    }
   else if ([[api_teamToken_field stringValue] isEqualToString:@""]) {
       return  NO;
    }
   else if ([[api_releaseNotes_field stringValue] isEqualToString:@""]) {
       return  NO;
    }
   else {
       return YES;
   }

}
- (IBAction)pressedHelp:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://testflightapp.com/api/doc/"]];
}

- (IBAction)pressed:(id)sender {
    if ([self fieldsFilled]) {
    [self performSelectorInBackground:@selector(upload) withObject:nil];
    }
    else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Success!"];
        [alert setInformativeText:@"You haven't added all the required fields"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        [alert release];
        
    }
}

- (IBAction)chooseIPAPressed:(id)sender {
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"ipa", @"IPA", nil]; //only allow IPAs
    
	NSOpenPanel *openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowedFileTypes:allowedFileTypes];
    
	if ([openDlg runModalForTypes:allowedFileTypes] == NSOKButton) {
        NSArray *files = [openDlg filenames];
        [api_ipa_path_field setStringValue:[files objectAtIndex:0]];
	}

}
- (void)upload {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *URL = [NSURL URLWithString: @"http://testflightapp.com/api/builds.json"] ;
	
	ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:URL] ;
	[post setRequestMethod:@"POST"] ;
	[post addPostValue:[api_token_field stringValue] forKey: @"api_token"];
    [post addPostValue:[api_teamToken_field stringValue] forKey: @"team_token"];
    [post addFile:[api_ipa_path_field stringValue] forKey:@"file"];
	[post addPostValue:[api_releaseNotes_field stringValue] forKey: @"notes"] ;

    [post setDidStartSelector: @selector(uploadStarted:)];
    [post setDidFinishSelector: @selector(uploadFinished:)];
    [post setDidFailSelector: @selector(uploadFailed:)];
    [post setDelegate:self] ;
    [post startSynchronous];
    [pool release];
}
- (void)uploadStarted:(ASIFormDataRequest *)post {
    
}
- (void)uploadFailed:(ASIFormDataRequest *)post {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Success!"];
    [alert setInformativeText:@"Your upload to testFlight failed"]; 
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
    [alert release];
   
 }
- (void)uploadFinished:(ASIFormDataRequest *)post {
    NSString *jsonResponse = [post responseString];
    NSDictionary *jsonItems = [jsonResponse JSONValue];
    NSString *messageText = [NSString stringWithFormat:@"Bundle Version: %@ \nInstall URL: %@ \nConfig URL: %@ \nCreated At: %@ \nDevice Family: %@ \nNotify: %@ \nTeam: %@ \nMinimum OS Version: %@ \nRelease Notes: %@ \nBinary Size: %@", 
                             
                             [jsonItems objectForKey:@"bundle_version"], 
                             [jsonItems objectForKey:@"install_url"], 
                             [jsonItems objectForKey:@"config_url"], 
                             [jsonItems objectForKey:@"created_at"], 
                             [jsonItems objectForKey:@"device_family"], 
                             [jsonItems objectForKey:@"notify"], 
                             [jsonItems objectForKey:@"team"], 
                             [jsonItems objectForKey:@"minimum_os_version"], 
                             [jsonItems objectForKey:@"release_notes"], 
                             [jsonItems objectForKey:@"binary_size"]];
                             
                                                                            
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Sweet"];
    [alert setMessageText:@"App upload successfully"];
    [alert setInformativeText:messageText]; 
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
    [alert release];
  

}
- (void)dealloc
{
    [super dealloc];
}

@end
