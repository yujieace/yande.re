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
    NSInteger currentIndex;
    CGFloat _lastPhotoScale;
    CGAffineTransform currentTransform;
}
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (nonatomic,strong) NSDictionary *param;
@property (nonatomic,strong) NSString * index;
@property (nonatomic,strong) UIImage *placeholder;
@property (nonatomic,strong) NSArray *Source;
@end
