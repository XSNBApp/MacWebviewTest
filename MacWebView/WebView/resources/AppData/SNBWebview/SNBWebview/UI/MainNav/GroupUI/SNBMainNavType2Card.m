//
//  SNBMainNavGroupSection.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import "SNBMainNavType2Card.h"
#import "SNBMainNavType2Cell.h"

@implementation SNBMainNavType2Card

- (NSUInteger)numberOfRows{
    return ([_type2Models count]+1)/2;
}

- (CGFloat)rowHeight{
    return 154/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row{
    SNBMainNavType2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNBMainNavType2Cell"];
    if (cell == nil) {
        cell = [[SNBMainNavType2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SNBMainNavType2Cell"];
    }
    cell.models = [_type2Models subarrayWithRange:NSMakeRange(row*2, MIN(2, [_type2Models count]-row*2))];
    return cell;
}

@end
