//  SNBMainNavType1Model.h
//  QQMSFContact
//
//  Created by brightshen on 14-9-28.
//
//

#import "SNBModel.h"

//群类型风格
@interface SNBMainNavType1Model : SNBModel

@property(nonatomic, strong) NSString *uin;   //群uin
@property(nonatomic, strong) NSString *name;   //群名称
@property(nonatomic, strong) NSString *imageURL; //群头像url
@property(nonatomic, strong) NSString *locationDescription; //地点
@property(nonatomic) UInt32 memberCount; //成员数

@property(nonatomic, strong) NSString *operationName; //操作名称
@property(nonatomic, strong) NSString *operationActionURL; //操作url

@property(nonatomic, strong) NSString *transferURL; //跳转url

@property(nonatomic, strong) NSString *cardTitle;   //groupcardtitle

- (void)update;

@end
