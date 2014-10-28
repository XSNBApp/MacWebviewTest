//
//  SNBModel.h
//  SNBWebview
//
//  Created by xxing on 14/10/28.
//  Copyright (c) 2014年 xxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNBModel : NSObject <NSCoding> {
    
}
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
