//
//  miniTagsController.h
//  yande.re
//
//  Created by hnzc on 16/7/12.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol miniTagsDelegate <NSObject>

-(void)tagsSelected:(NSString *)tags;

@end

@interface miniTagsController : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *tags;
@property (nonatomic,strong) NSArray *source;
@property (nonatomic,weak) id<miniTagsDelegate>delegate;
@end
