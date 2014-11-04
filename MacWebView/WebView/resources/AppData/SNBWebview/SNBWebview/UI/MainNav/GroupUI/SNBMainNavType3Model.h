//
//  SNBMainNavType1Model.h
//  QQMSFContact
//
//  Created by xxing on 14-9-28.
//
//

#import "SNBModel.h"

//部落类型风格
@interface SNBMainNavType3Model : SNBModel

@property(nonatomic, strong) NSString *name;   //部落名称
@property(nonatomic, strong) NSString *imageURL; //部落头像url
@property(nonatomic, strong) NSString *locationDescription; //地点

@property(nonatomic, strong) NSString * desc1; //话题数
@property(nonatomic, strong) NSString * desc2; //关注数

@property(nonatomic, strong) NSString *transferURL; //跳转url

@end
