//
//  CommenPostdelegate.h
//  yande.re
//
//  Created by YuJie on 16/4/25.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceModule.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+ToString.h"
#import "RatingFilter.h"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
typedef void(^Didselect)(NSIndexPath *index,NSDictionary *post);
typedef void(^CellModify)(UICollectionViewCell *cell,NSIndexPath *index,NSDictionary *post);
typedef void(^Scrolled)(NSInteger y);
@interface CommenPostdelegate : UIViewController<UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    NSMutableArray *Source;
    NSInteger width;
    NSInteger height;
    Didselect DidSelectBlock;
    CellModify CellModifyBlock;
    Scrolled scrolledBlock;
}
-(instancetype)init;/**>初始化代理对象*/
-(void)SetDidSelectBlock:(Didselect)block;/**>设置点击对应cell后处理的Block回调,若强引用了self，需将self置为weakself*/
-(void)setCellModifyBlock:(CellModify)block;/**>设置Cell处理方法，设置后可对cell进行二次更改，默认格式为UIImageView Tag=2,UIlabel Tag=3，若强引用了self，需将self置为weakself*/
-(void)setSource:(NSArray *)array;/**>设置数据源，可多次设置，设置后数据源内容清空并设置为新数据源*/
-(void)setScrollBlock:(Scrolled)block;

@end
