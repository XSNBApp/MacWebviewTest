//
//  QQHotItemCell.h
//  QQMSFContact
//
//  Created by brightshen on 14-10-15.
//
//

#import "SNBMainNavHotItemModel.h"

#define HOT_ITEM_BUTTON_WIDTH 48
#define HOT_ITEM_BUTTON_HEIGHT 61

@interface SNBMainNavHotItemButton : UIButton

@property(nonatomic, strong) SNBMainNavHotItemModel *model;

@end
