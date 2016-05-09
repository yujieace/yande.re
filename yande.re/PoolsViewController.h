//
//  PoolsViewController.h
//  yande.re
//
//  Created by 於杰 on 16/4/12.
//  Copyright © 2016年 於杰. All rights reserved.
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
