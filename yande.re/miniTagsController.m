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
@interface miniTagsController ()

@end

@implementation miniTagsController

-(instancetype)init
{
    self=[super init];
    _tags=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
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
    TagsCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell.title.text=[_source objectAtIndex:indexPath.row];
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
    CGFloat width=[self widthForString:text fontSize:25 andHeight:30];
    CGFloat height=30;
    return CGSizeMake(width, height);
}

-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

@end
