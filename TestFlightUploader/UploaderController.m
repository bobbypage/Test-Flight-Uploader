//
//  UploaderController.m
//  TestFlightUploader
//
//  Created by David Porter on 5/13/11.
//  Copyright 2011 David Porter Apps. All rights reserved.
//

#import "UploaderController.h"
#import "AFNetworking.h"
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

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/bobbypage/Test-Flight-Uploader"]];
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
        
    }
}

- (IBAction)chooseIPAPressed:(id)sender {
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"ipa", @"IPA", nil]; //only allow IPAs
    
	NSOpenPanel *openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowedFileTypes:allowedFileTypes];

    [openDlg beginSheetModalForWindow:[NSApp keyWindow]
                  completionHandler: ^(NSInteger result) {
                      if (result == NSFileHandlingPanelOKButton) {
                          NSURL *url = [[openDlg URLs] objectAtIndex: 0];
                          ipaData = [[NSData alloc] initWithContentsOfURL:url];
                          [api_ipa_path_field setStringValue:[url absoluteString]];

                      }
                  }];

}
- (void)upload {    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [api_token_field stringValue] , @"api_token",
                            [api_teamToken_field stringValue], @"team_token",
                            [api_releaseNotes_field stringValue], @"notes",
                            nil];
    
    AFHTTPClient *httpClient = 
    [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://testflightapp.com/"]];
    NSMutableURLRequest *request = [httpClient      
                                      multipartFormRequestWithMethod:@"POST"
                                      path:@"api/builds.json"  
                                      parameters:params
                                      constructingBodyWithBlock:
                                      ^(id <AFMultipartFormData>formData) {
                                          [formData appendPartWithFileData:ipaData                                
                                                                      name:@"file"
                                                                  fileName:@"app.ipa"
                                                                  mimeType:@"application/octet-stream"];
                                      } 
                                      ]; 
    
    
   __block AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       
       NSString *messageText = [NSString stringWithFormat:@"Hooray!\nHere are some details:\n\nBundle Version: %@ \nInstall URL: %@ \nConfig URL: %@ \nCreated At: %@ \nDevice Family: %@ \nNotify: %@ \nTeam: %@ \nMinimum OS Version: %@ \nRelease Notes: %@ \nBinary Size: %@", 
                                
                                [JSON objectForKey:@"bundle_version"], 
                                [JSON objectForKey:@"install_url"], 
                                [JSON objectForKey:@"config_url"], 
                                [JSON objectForKey:@"created_at"], 
                                [JSON objectForKey:@"device_family"], 
                                [JSON objectForKey:@"notify"], 
                                [JSON objectForKey:@"team"], 
                                [JSON objectForKey:@"minimum_os_version"], 
                                [JSON objectForKey:@"release_notes"], 
                                [JSON objectForKey:@"binary_size"]];
       
       [self showAlertWithTitle:@"Uploaded IPA successfully" message:messageText dismissButtonTitle:@"OK"];


    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self showAlertWithTitle:@"Oops, upload failed!" message:operation.responseString dismissButtonTitle:@"OK"];
    }];
    
    [operation setUploadProgressBlock:   
     ^(NSInteger bytesWritten, NSInteger totalBytesWritten,
       NSInteger totalBytesExpectedToWrite) {
         float percentDone = (((float)((int)totalBytesWritten) / (float)((int)totalBytesExpectedToWrite))*100);
//         NSLog(@"Sent %ld of %ld bytes", totalBytesWritten, totalBytesExpectedToWrite);
         [uploadProgressLabel setStringValue:[NSString stringWithFormat:@"Upload Progress: %.f%%", percentDone]];
     }
     ];  
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}
- (IBAction)showTwitter:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://twitter.com/bobbypage"]];

}
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)messageTitle dismissButtonTitle:(NSString *)dismissButtonTitle {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:title];
    [alert addButtonWithTitle:dismissButtonTitle];
    [alert setInformativeText:messageTitle]; 
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
}

@end
