//
//  PoolsViewController.h
//  yande.re
//
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenPoolDelegate.h"
@interface PoolsViewController : UIViewController
{
    CommenPoolDelegate *del;
}
@property (weak, nonatomic) IBOutlet UICollectionView *PoolsCollectView;
@property (nonatomic,strong) NSMutableArray *souce;
@property NSInteger page;
@end
