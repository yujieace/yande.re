//
//  FavouriteViewController.h
//  yande.re
//
//  Created by 於杰 on 16/4/27.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTabedSlideView.h"
@interface FavouriteViewController : UIViewController<DLTabedSlideViewDelegate>
@property (weak, nonatomic) IBOutlet DLTabedSlideView *slide;

@end
