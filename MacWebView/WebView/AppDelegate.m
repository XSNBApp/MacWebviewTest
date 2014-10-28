//
//  AppDelegate.m
//  WebApp2
//
//  Created by  on 7/3/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "CustomNSWindow.h"

@interface AppDelegate ()

@property (weak) IBOutlet CustomNSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window setupWebPage];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
