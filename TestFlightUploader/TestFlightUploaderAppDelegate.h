//
//  TestFlightUploaderAppDelegate.h
//  TestFlightUploader
//
//  Created by David Porter on 5/13/11.
//  Copyright 2011 David Porter Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define Token @"9d66607f396923f66ddbd5bc25173ea8_Nzc2"
@class BuilderController;

@interface TestFlightUploaderAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    BuilderController *builderController;

}
@property (nonatomic, retain) IBOutlet BuilderController *builderController;

@property (assign) IBOutlet NSWindow *window;

@end
