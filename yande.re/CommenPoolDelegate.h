//
//  CommenPoolDelegate.h
//  yande.re
//
//  Created by 於杰 on 16/4/25.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingFilter.h"
#import "CommenPostdelegate.h"
#define SCREEN_SIZE self.view.bounds.size
@interface CommenPoolDelegate : CommenPostdelegate
{
    CGFloat StandWidth;
    CGFloat StandHeight;
    CGFloat WideWidth;
    CGFloat WideHeight;
}
-(instancetype)init;
@end
