//
//  ShowDetailPic.h
//  yande.re
//
//  Created by 於杰 on 16/4/11.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceModule.h"

@interface ShowDetailPic : UIViewController<UIGestureRecognizerDelegate>
{
    BOOL isLiked;
    PreferenceModule *Preference;
    UIBarButtonItem *like;
    UIBarButtonItem *download;
    NSArray *Source;
}
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (nonatomic,strong) NSDictionary *param;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wideConstraint;
@property (nonatomic,strong) NSString * index;
@property (nonatomic,strong) UIImage *placeholder;
@end
