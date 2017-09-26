//
//  CommenPostdelegate.m
//  yande.re
//
//  Created by YuJie on 16/4/25.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "CommenPostdelegate.h"
@implementation CommenPostdelegate
-(instancetype)init
{
    if(self.view.bounds.size.width>self.view.bounds.size.height)
    {
        //设备横向
        width=self.view.bounds.size.height;
        height=self.view.bounds.size.width;
    }
    else
    {
        width=self.view.bounds.size.width;
        height=self.view.bounds.size.height;
    }
    Source=[[NSMutableArray alloc] init];
    return self;
}
-(void)setScrollBlock:(Scrolled)block
{
    scrolledBlock=block;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrolledBlock!=nil)
    scrolledBlock(scrollView.contentOffset.y);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return Source.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dic=[Source objectAtIndex:indexPath.row];
    UIImageView *image=[cell viewWithTag:2];
    if(image==nil)
    {
        image=[[UIImageView alloc] initWithFrame:cell.bounds];
        image.tag=2;
    }
    image.contentMode=UIViewContentModeScaleAspectFill;
    NSString *url=[dic valueForKey:@"preview_url"];
    if([url hasPrefix:@"http"])
    {
        
    }
    else
    {
        url=[NSString stringWithFormat:@"http:%@",url];
    }
    [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell addSubview:image];
    UILabel *label=[cell viewWithTag:3];
    if (label==nil) {
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, image.bounds.size.height-30, image.bounds.size.width, 30)];
        label.tag=3;
    }
    label.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    label.text=[NSString stringWithFormat:@"评级:%@",[RatingFilter RatingLevel:dic]];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor whiteColor];
    [cell addSubview:label];
    
    
    
    if(CellModifyBlock!=nil)
    {
        CellModifyBlock(cell,indexPath,dic);
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 5);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 5);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(isPad)
    {
        return CGSizeMake((width-30)/4, (width-30)/4);
    }
    else
    {
        return CGSizeMake((width-5)/2, (width-5)/2);
    }
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if(isPad)
        return 10;
    else
        return 5;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(isPad)
        return 10;
    else
        return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *post=[Source objectAtIndex:indexPath.row];
    if(DidSelectBlock!=nil)
    DidSelectBlock(indexPath,post);
}
-(void)SetDidSelectBlock:(Didselect)block
{
    DidSelectBlock=block;
}
-(void)setCellModifyBlock:(CellModify)block
{
    CellModifyBlock=block;
}
-(void)setSource:(NSArray *)array
{
    
    [Source removeAllObjects];
    [Source addObjectsFromArray:array];
}
@end
