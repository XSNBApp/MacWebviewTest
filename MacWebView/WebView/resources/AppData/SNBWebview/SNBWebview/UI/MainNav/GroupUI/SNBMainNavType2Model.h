//
//  SNBMainNavType1Model.h
//  QQMSFContact
//
//  Created by brightshen on 14-9-28.
//
//

#import "SNBModel.h"

//活动类型风格
@interface SNBMainNavType2Model : SNBModel

@property(nonatomic, strong) NSString *name;   //活动名称
@property(nonatomic, strong) NSString *imageURL; //活动封面URL
@property(nonatomic, strong) NSString *desc; //活动报名人数

@property(nonatomic, strong) NSString *transferURL; //跳转url

@end
