//
//  SNBMainNavCardHeaderCell.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-28.
//
//

#import "SNBMainNavCardHeaderCell.h"
#import "QQAsynUrlImageView.h"

@implementation SNBMainNavCardHeaderCell{
    QQAsynUrlImageView *_iconView;
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[QQAsynUrlImageView alloc] initWithFrame:CGRectMake(15, (self.contentView.height-17)/2, 17, 17) defaultImage:nil];
        _iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, (self.contentView.height-20)/2, 200, 20)];
        _nameLabel.skinTextColorNormal = kContentTitleTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_nameLabel];
        
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateContentWithCard:(SNBMainNavCard *)card{
    [_iconView loadUrlImage:card.iconURL];
    _nameLabel.text = card.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
