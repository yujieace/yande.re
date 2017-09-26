//
//  FavouritePools.h
//  yande.re
//
//  Created by YuJie on 16/4/27.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenPoolDelegate.h"
#import "PreferenceModule.h"
@interface FavouritePools : UIViewController
{
    CommenPoolDelegate *pool;
    PreferenceModule *prefrence;
}
@property (weak, nonatomic) IBOutlet UICollectionView *PoolsCollection;
@end
