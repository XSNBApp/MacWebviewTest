//
//  SNBMainNavGroupCell.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import "SNBMainNavType1Cell.h"
#import "QQAsynUrlImageView.h"
#import "UIImage+Color.h"
#import "QQAsynHeadImageView.h"
#import "UniLogUploadEngine.h"
#import "QQURLBuilder.h"

@implementation SNBMainNavType1Cell{
    //QQAsynUrlImageView *_iconView;
    QQAsynHeadImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_groupCountLabel;
    UILabel *_locationLabel;
    UIButton *_joinButton;
    UIImageView *_locationIconView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _iconView = [[QQAsynUrlImageView alloc] initWithFrame:CGRectMake(15, (self.contentView.height-50)/2, 50, 50) defaultImage:LOAD_DEFAULT_ICON_USE_POOL(@"group_avatar_default_0.png")];
        
        _iconView = [[QQAsynHeadImageView alloc] initWithFrame:CGRectMake(10, (self.contentView.height-50)/2 + 13, 50, 50)
                                                           sizeType:HEADIMAGE_SIZE_SMALL
                                                            isRound:YES];
        _iconView.userType = HEADUSERTYPE_GROUP;

        
        
        //_iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 15, self.contentView.width - (320-170), 18)];
        _nameLabel.skinTextColorNormal = kContentTitleTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        UIImageView *groupCountIconView = [[UIImageView alloc] initWithImage:LOAD_ICON_USE_POOL_NO_CACHE(@"nearby_group_num.png")];
        groupCountIconView.center = CGPointMake(77, self.contentView.height-22);
        groupCountIconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:groupCountIconView];
        
        _groupCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, self.contentView.height-34, 30, 24)];
        _groupCountLabel.font = [UIFont systemFontOfSize:12];
        _groupCountLabel.skinTextColorNormal = kContentDescriptionTextColor;
        _groupCountLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _groupCountLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_groupCountLabel];
        
       _locationIconView = [[UIImageView alloc] initWithImage:LOAD_ICON_USE_POOL_NO_CACHE(@"search_group_icon_geo2")];
        _locationIconView.center = CGPointMake(120, self.contentView.height-22);
        _locationIconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_locationIconView];
 
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, self.contentView.height-34, self.contentView.width-75-136, 24)];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        _locationLabel.skinTextColorNormal = kContentDescriptionTextColor;
        _locationLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_locationLabel];

        if ([[UIDevice currentDevice].systemVersion floatValue] > 6.99) self.separatorInset = UIEdgeInsetsZero;
        
        _joinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-15-52, (self.contentView.bounds.size.height-22)/2, 44, 22)];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinButton setTitleColor:[UIColor colorWithRed:0x18/255.0 green:0xb4/255.0 blue:0xed/255.0 alpha:1] forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1] forState:UIControlStateHighlighted];
        [_joinButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [_joinButton setFont:[UIFont systemFontOfSize:13]];
        _joinButton.layer.cornerRadius = 2;
        _joinButton.layer.borderWidth = MIN(1/[UIScreen mainScreen].scale, 0.5);
        _joinButton.layer.borderColor = [UIColor colorWithWhite:0xca/255.0 alpha:1].CGColor;
        _joinButton.clipsToBounds = YES;
        [_joinButton addTarget:self action:@selector(joinButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_joinButton];
        [_joinButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (/*!self.selected &&*/ selected && _model.transferURL) {
        extern NSString *const SNBMainNavViewControllerDidClickTransferURLNotification;
        
        NSString *actionURL = [self addURLSourceID: _model.transferURL];
        [[NSNotificationCenter defaultCenter] postNotificationName:SNBMainNavViewControllerDidClickTransferURLNotification object:nil userInfo:@{@"url":actionURL}];
        
        [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_Clk_grpdata opEnter:0 opResult:0 reserve:_model.uin,_model.cardTitle,nil];
    }
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(SNBMainNavType1Model *)model{
    if (_model != model) {
        _model = model;
        //[_iconView loadUrlImage:_model.imageURL];
        _iconView.uin = model.uin;
        [_iconView loadHeadImage:model.uin];
    
        _nameLabel.text = model.name;
        _groupCountLabel.text = [NSString stringWithFormat:@"%u",_model.memberCount];
        _locationLabel.text = model.locationDescription;
        _locationIconView.hidden = model.locationDescription.length <= 0;
        
        [_joinButton setTitle:model.operationName forState:UIControlStateNormal];
    }
}

- (void)joinButtonAction{
    if (_model.operationActionURL) {
        

        NSString *actionURL = [self addURLSourceID:_model.operationActionURL];
        
        extern NSString *const SNBMainNavViewControllerDidClickTransferURLNotification;
        [[NSNotificationCenter defaultCenter] postNotificationName:SNBMainNavViewControllerDidClickTransferURLNotification object:nil userInfo:@{@"url":actionURL}];
        
        
        [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_Clk_join opEnter:0 opResult:0 reserve:_model.uin,_model.cardTitle,nil];
    }
}

- (NSString*)addURLSourceID:(NSString*)urlStr
{
//    kGrpIOSSrc_groupSearchNearbyGrp = 6, //群搜索中的附近的群
//    kGrpIOSSrc_groupSearchGroupRe = 7,   //群搜索中的 群推荐
    
    if (![urlStr.lowercaseString hasPrefix:@"mqqapi://card/show_pslcard"])
    {
        return urlStr;
    }
    
    QQURLBuilder *builder = [[QQURLBuilder alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    NSString* cardType = [builder getQueryParameter:@"card_type"];
    
    if (![cardType isEqualToString:@"group" ])
    {
        return urlStr;
    }
    
    NSString *strID = @"groupSearchNearbyGrp";
    if ([_model.cardTitle isEqualToString: @"附近的群"])
    {
        strID = @"groupSearchNearbyGrp";
    }
    else
    {
        strID = @"groupSearchGroupRecommend";
    }
    
    [builder addQueryParameter:@"jump_from" withValue:strID];
    
    return [[builder getURL] absoluteString];
}

@end
