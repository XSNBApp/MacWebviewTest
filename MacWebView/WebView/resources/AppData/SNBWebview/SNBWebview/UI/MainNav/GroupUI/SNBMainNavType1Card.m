//
//  SNBMainNavGroupSection.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import "SNBMainNavType1Card.h"
#import "SNBMainNavType1Cell.h"

@implementation SNBMainNavType1Card

- (NSUInteger)numberOfRows{
    return [_type1Models count];
}

- (CGFloat)rowHeight{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row{
    SNBMainNavType1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNBMainNavGroupCell"];
    if (cell == nil) {
        cell = [[SNBMainNavType1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SNBMainNavGroupCell"];
    }
    cell.model = _type1Models[row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
