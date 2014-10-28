//
//  CustomNSWindow.m
//  WebApp2
//
//  Created by  on 7/3/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "CustomNSWindow.h"
#import <WebKit/WebKit.h>
@interface CustomNSWindow()



@end


@implementation CustomNSWindow

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    self.title = title;

}

- (void)setupWebPage
{
    [self.webView setUIDelegate:self];
    NSString *urlAddress = @"http://dribbble.com/";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [[self.webView mainFrame] loadRequest:requestObj];
    [self setContentView:self.webView];
}

-(void)windowDidEndLiveResize
{
    NSLog(@"Glad to get that over with");
}

/*
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    // Only report feedback for the main frame.
    if (frame == [sender mainFrame]){
        NSString *url = [[[[frame provisionalDataSource] request] URL] absoluteString];
        NSLog(@"Title: %@", url);
    }
}
*/
@end
