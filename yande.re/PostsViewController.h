//
//  PostsViewController.h
//  yande.re
//
//  Created by 於杰 on 16/4/13.
//  Copyright © 2016年 於杰. All rights reserved.
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
