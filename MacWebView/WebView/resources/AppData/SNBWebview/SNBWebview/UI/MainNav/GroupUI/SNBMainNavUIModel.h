//
//  SNBMainNavUIModel.h
//  SNBWebview
//
//  Created by xxing on 14/11/3.
//  Copyright (c) 2014年 xxing. All rights reserved.
//

#import "SNBModel.h"

@interface SNBMainNavUIModel : SNBModel

//
@property(nonatomic,strong) NSArray *bannerUrlArray;
@property(nonatomic,strong) NSDictionary *bannerUrl2Action;
@property (nonatomic) float bannerInterval;

//
@property (nonatomic,strong) NSString * hotItemTitleIconURL;
@property (nonatomic,strong) NSString * hotItemTitle;
@property(nonatomic, strong) NSArray *hotItems;
//
@property(nonatomic, strong) NSArray *cards;


@end
