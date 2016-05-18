//
//  TagsDelegate.m
//  yande.re
//
//  Created by hnzc on 16/5/18.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "TagsDelegate.h"

@interface TagsDelegate ()

@end

@implementation TagsDelegate

-(instancetype)init
{
    self=[super init];
    return self;
}

-(instancetype)initWithTags:(NSArray *)tags
{
    self=[self init];
    tagSource=[[NSMutableArray alloc] initWithArray:tags];
    [self CalculateCellWidth];
    return self;
}

/**
 *  计算每个cell的长度以实现流式布局
 */
-(void)CalculateCellWidth
{
    if(widthArray==nil)
    {
        widthArray=[[NSMutableArray alloc] init];
    }else
    {
        [widthArray removeAllObjects];
    }
    
    for (NSDictionary *temp in tagSource) {
        NSString *tagName=[temp valueForKey:@"name"];
        NSUInteger width=tagName.length*10;
        [widthArray addObject:[NSString stringWithFormat:@"%lu",width]];
    }
}

-(void)setTagDidTapedBlock:(tagDidTaped)block
{
    tapedBlock=block;
}
-(void)setTags:(NSArray *)tags
{
    if(tagSource==nil)
    {
        tagSource=[[NSMutableArray alloc] init];
    }
    else
    {
        [tagSource removeAllObjects];
    }
    
    [self CalculateCellWidth];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tagSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic=[tagSource objectAtIndex:indexPath.row];
    UILabel *name=[cell viewWithTag:2];
    if(name==nil)
    {
        name=[[UILabel alloc] initWithFrame:cell.bounds];
        name.tag=2;
    }
    name.textColor=[UIColor grayColor];
    name.textAlignment=NSTextAlignmentCenter;
    name.text=[dic valueForKey:@"name"];
    [cell addSubview:name];
    cell.backgroundColor=[UIColor colorWithRed:0.822 green:0.878 blue:1.000 alpha:1.000];
    cell.layer.cornerRadius=5;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *width=[widthArray objectAtIndex:indexPath.row];
    return CGSizeMake([width integerValue], 30);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(tapedBlock!=nil)
    {
        tapedBlock(indexPath,[tagSource objectAtIndex:indexPath.row]);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
