//
//  PostsViewController.h
//  yande.re
//
//  Created by YuJie on 16/4/13.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenPostdelegate.h"
#import "PreferenceModule.h"
@interface PostsViewController : UIViewController
{
    CommenPostdelegate *del;
    BOOL isLiked;
    PreferenceModule *Preference;
    UIBarButtonItem *like;
    NSDictionary *param;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSDictionary *pool;
@property (nonatomic,strong) NSMutableArray *Source;
@end
