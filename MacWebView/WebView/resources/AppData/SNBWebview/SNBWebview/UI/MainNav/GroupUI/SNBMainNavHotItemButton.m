//
//  QQHotItemCell.m
//  QQMSFContact
//
//  Created by xxing on 14-10-15.
//
//

#import "SNBMainNavHotItemButton.h"
#import "SNBAsynUrlImageView.h"

@implementation SNBMainNavHotItemButton{
    SNBAsynUrlImageView *_imageView;
    UILabel *_nameLabel;
}

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, HOT_ITEM_BUTTON_WIDTH, HOT_ITEM_BUTTON_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[SNBAsynUrlImageView alloc] initWithFrame:CGRectMake((frame.size.width-48)/2, 0, 48, 48)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, frame.size.width, 13)];
        _nameLabel.font = [UIFont systemFontOfSize:11];
    
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setModel:(SNBMainNavHotItemModel *)model{
    if (_model != model) {
        _model = model;
        [_imageView sd_setImageWithURL:[NSURL URLWithString: _model.imageURL]];
        _nameLabel.text = model.name;
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        _imageView.alpha = 0.75;
        _nameLabel.alpha = 0.75;
    }
    else{
        _imageView.alpha = 1;
        _nameLabel.alpha = 1;
    }
}

@end
