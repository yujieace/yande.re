//
//  miniTagsController.m
//  yande.re
//
//  Created by hnzc on 16/7/12.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "miniTagsController.h"
#import "TagsCell.h"
#import <Masonry.h>
#import <UICollectionViewLeftAlignedLayout.h>
#import <YYText.h>
@interface miniTagsController ()

@end

@implementation miniTagsController

-(instancetype)init
{
    self=[super init];
    UICollectionViewLeftAlignedLayout *layout= [[UICollectionViewLeftAlignedLayout alloc] init];
    _tags=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _source=[[NSArray alloc] init];
    [self addSubview:_tags];
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    _tags.backgroundColor=[UIColor clearColor];
    _tags.dataSource=self;
    _tags.delegate=self;
    [_tags registerClass:[TagsCell class] forCellWithReuseIdentifier:@"Cell"];
    [_tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _source.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagsCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *text=[_source objectAtIndex:indexPath.row];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange strRange = {0,[str length]};
    //[str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:strRange];
    [cell.title setAttributedText:str];
    NSLog(@"%f,%f",cell.frame.origin.x,cell.frame.origin.y);
    [cell setNeedsDisplay];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(tagsSelected:)])
    {
        [_delegate tagsSelected:[_source objectAtIndex:indexPath.row]];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text=[_source objectAtIndex:indexPath.row];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange strRange = {0,[str length]};
    //[str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:strRange];
    YYTextLayout *layout =[YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, 20) text:str];
    CGFloat width=layout.textBoundingRect.size.width+30;
    CGFloat height=30;
    return CGSizeMake(width, height);
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

@end
