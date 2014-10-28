//
//  SNBMainNavGroupSection.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import "SNBMainNavType3Card.h"
#import "SNBMainNavType3Cell.h"

@implementation SNBMainNavType3Card

- (NSUInteger)numberOfRows{
    return ([_type3Models count]+1)/2;
}

- (CGFloat)rowHeight{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row{
    SNBMainNavType3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNBMainNavType3Cell"];
    if (cell == nil) {
        cell = [[SNBMainNavType3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SNBMainNavType3Cell"];
    }
    cell.models = [_type3Models subarrayWithRange:NSMakeRange(row*2, MIN(2, [_type3Models count]-row*2))];
    return cell;
}



@end
