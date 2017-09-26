//
//  PhotoViewController.h
//  yande.re
//
//  Created by YuJie on 16/5/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceModule.h"
@interface PhotoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIScrollView *scrollview;
    
    BOOL isLiked;
    PreferenceModule *Preference;
    UIBarButtonItem *like;
    UIBarButtonItem *download;
    UIBarButtonItem *share;
    __block UIImage *currentImage;
    NSInteger currentIndex;
}
@property (nonatomic,strong) __block NSDictionary *param;
@property (nonatomic,strong) NSString * index;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic,strong) UIImage *placeholder;
@property (nonatomic,strong) NSArray *Source;
@end
