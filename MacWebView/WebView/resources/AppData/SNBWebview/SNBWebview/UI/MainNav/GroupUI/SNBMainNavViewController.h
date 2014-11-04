//
//  SNBMainNavViewController.h
//  QQMSFContact
//
//  Created by xxing on 14-9-25.
//
//

#import <UIKit/UIKit.h>
#import "SNBMainNavUIModel.h"


extern NSString *const SNBMainNavViewControllerDidClickTransferURLNotification;

@interface SNBMainNavViewController : UIViewController

@property (nonatomic,strong) SNBMainNavUIModel *uiModel;
@end
