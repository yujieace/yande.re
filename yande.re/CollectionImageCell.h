//
//  CollectionImageCell.h
//  yande.re
//
//  Created by 於杰 on 2018/10/4.
//  Copyright © 2018 hnzc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionImageCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *addCollection;
@end

NS_ASSUME_NONNULL_END
