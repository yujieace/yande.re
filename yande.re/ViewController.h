//
//  ViewController.h
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenPostdelegate.h"
@interface ViewController : UIViewController<UIScrollViewDelegate>
{
    CommenPostdelegate *del;
    __block CGFloat percent;
}

@end

