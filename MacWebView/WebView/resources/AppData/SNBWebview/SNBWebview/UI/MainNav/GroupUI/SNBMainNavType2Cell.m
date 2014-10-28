//
//  SNBMainNavGroupCell.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import "SNBMainNavType2Cell.h"
#import "QQAsynUrlImageView.h"
#import "UniLogUploadEngine.h"
#import "QLineView.h"

@interface SNBMainNavType2Button : UIButton

@property(nonatomic, strong) SNBMainNavType2Model *model;

@end

@implementation SNBMainNavType2Button{
    QQAsynUrlImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_detailLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[QQAsynUrlImageView alloc] initWithFrame:CGRectMake(15, 10, 76/2, 114/2) defaultImage:nil];
        [self addSubview:_iconView];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 8, self.bounds.size.width-73, 34)];
        _nameLabel.skinTextColorNormal = kContentTitleTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _nameLabel.numberOfLines = 2;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 134/2-15, self.bounds.size.width-73, 14)];
        _detailLabel.skinTextColorNormal = kContentDescriptionTextColor;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _detailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)setModel:(SNBMainNavType2Model *)model{
    if (model != _model) {
        _model = model;
        [_iconView loadUrlImage:_model.imageURL];
        _nameLabel.text = _model.name;
        _detailLabel.text = model.desc;
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.alpha = 0.75;
    }
    else{
        self.alpha = 1;
    }
}


@end

@implementation SNBMainNavType2Cell{
    SNBMainNavType2Button *_button1;
    SNBMainNavType2Button *_button2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _button1 = [[SNBMainNavType2Button alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width/2, self.contentView.height)];
        _button1.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        [_button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button1];
        
        _button2 = [[SNBMainNavType2Button alloc] initWithFrame:CGRectMake(self.contentView.width/2, 0, self.contentView.width/2, self.contentView.height)];
        _button2.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        [_button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button2];
        
        QLineView *lineView = [[QLineView alloc] initWithFrame:CGRectMake(self.contentView.width/2, 0, 1, self.contentView.height)];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        lineView.lineColor = [UIColor colorWithWhite:0xdd/255.0 alpha:1];
        [self.contentView addSubview:lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModels:(NSArray *)models{
    if (_models != models) {
        _models = models;
        if ([models count] >= 1) {
            _button1.hidden = NO;
            _button1.model = models[0];
        }
        else{
            _button1.hidden = YES;
        }
        
        if ([models count] >= 2) {
            _button2.hidden = NO;
            _button2.model = models[1];
        }
        else{
            _button2.hidden = YES;
        }
    }
}

- (void)buttonAction:(id)button{
    NSString *transferURL = nil;
    if (button == _button1) {
        transferURL = ((SNBMainNavType2Model *)_models[0]).transferURL;
    }
    else {
        transferURL = ((SNBMainNavType2Model *)_models[1]).transferURL;
    }
    if ([transferURL length]) {
        extern NSString *const SNBMainNavViewControllerDidClickTransferURLNotification;
        [[NSNotificationCenter defaultCenter] postNotificationName:SNBMainNavViewControllerDidClickTransferURLNotification object:nil userInfo:@{@"url":transferURL}];

    }
    
    [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_Clk_localac opEnter:0 opResult:0 reserve:nil];
}

@end
