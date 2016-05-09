//
//  FavouritePost.h
//  yande.re
//
//  Created by 於杰 on 16/4/27.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenPostdelegate.h"
#import "PreferenceModule.h"
@interface FavouritePost : UIViewController
{
    CommenPostdelegate *del;
    PreferenceModule *pre;
    NSMutableArray *Source;
}
@property (weak, nonatomic) IBOutlet UICollectionView *postCollection;

@end
