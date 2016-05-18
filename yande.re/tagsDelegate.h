//
//  TagsDelegate.h
//  yande.re
//
//  Created by hnzc on 16/5/18.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tagDidTaped)(NSIndexPath *indexPath,NSDictionary *tag);
/**
 *  Tags数据源和代理类
 */
@interface TagsDelegate:UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *tagSource;
    tagDidTaped tapedBlock;
    NSMutableArray *widthArray;
}
/**
 *  初始化数据源
 *
 *  @param tags tags数组
 *
 *  @return self
 */
-(instancetype)initWithTags:(NSArray *)tags;

/**
 *  设置选择tag后的block
 *
 *  @param block block逻辑
 */
-(void)setTagDidTapedBlock:(tagDidTaped)block;

/**
 *  设置tags数据源，将触发长度重新计算
 *
 *  @param tags tags数组
 */
-(void)setTags:(NSArray *)tags;

/**
 *  默认初始化
 *
 *  @return self
 */
-(instancetype)init;
@end
