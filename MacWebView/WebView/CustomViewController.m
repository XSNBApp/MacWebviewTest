//
//  CustomViewController.m
//  WebApp2
//
//  Created by  on 7/3/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "CustomViewController.h"
#import "CustomNSWindow.h"

@implementation CustomViewController

- (void)windowDidResize:(NSNotification *)notification
{
    CustomNSWindow *win = (CustomNSWindow *)[notification object];
    
    NSLog(@"%f", win.frame.size.width );
    
    float height = win.frame.size.height;
    float width = win.frame.size.width;
    
    CGRect frame = CGRectMake(0,0,width,height);
    
    //win.webView.frame = frame;
    
  //  win.webView.frame.height = win.frame.size.height;

}


@end
