//
//  SNBMainNavSection.h
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SNBMainNavCard : NSObject

@property(nonatomic, strong) NSString *iconURL;
@property(nonatomic, strong) NSString *name;

@property(nonatomic, readonly) NSUInteger numberOfRows;
@property(nonatomic, readonly) CGFloat rowHeight;

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRow:(NSInteger)row;

@property(nonatomic, strong) NSString *transferDescription;
@property(nonatomic, strong) NSString *transferURL;

@end
