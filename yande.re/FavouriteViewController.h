//
//  FavouriteViewController.h
//  yande.re
//
//  Created by YuJie on 16/4/27.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTabedSlideView.h"
@interface FavouriteViewController : UIViewController<DLTabedSlideViewDelegate>
@property (weak, nonatomic) IBOutlet DLTabedSlideView *slide;

@end
