//
//  UploaderController.h
//  TestFlightUploader
//
//  Created by David Porter on 5/13/11.
//  Copyright 2011 David Porter Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface UploaderController : NSObject {
@private
    IBOutlet NSTextField *api_ipa_path_field;
    IBOutlet NSTextField *api_releaseNotes_field;
    IBOutlet NSTextField *api_teamToken_field;
    IBOutlet NSTextField *api_token_field;
}
- (IBAction)pressedHelp:(id)sender;
- (IBAction)pressed:(id)sender;
- (IBAction)chooseIPAPressed:(id)sender;
- (void)upload;
@end
