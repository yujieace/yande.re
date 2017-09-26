//
//  CommenPoolDelegate.m
//  yande.re
//
//  Created by YuJie on 16/4/25.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "CommenPoolDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CommenPoolDelegate
-(instancetype)init
{
    self=[super init];
    [self checkDirection];
    return self;
}
-(void)checkDirection
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
    StandWidth=(width-40)/3;
    StandHeight=StandWidth/0.8;
    
    WideWidth=(height-60)/4;
    WideHeight=WideWidth/0.8;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=[Source objectAtIndex:indexPath.row];
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    UILabel *name=[cell viewWithTag:10];
    if(name==nil)
    {
        name=[[UILabel alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-30, cell.bounds.size.width, 30)];
        name.tag=10;
        
    }
    name.textAlignment=NSTextAlignmentCenter;
    name.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
    name.textColor=[UIColor whiteColor];
    name.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UILabel *count=[cell viewWithTag:20];
    if(count==nil)
    {
        count=[[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width-50, 0, 50, 30)];
        count.tag=20;
        
    }
    count.text=[NSString stringWithFormat:@"%@张",[dic valueForKey:@"post_count"]];
    count.textAlignment=NSTextAlignmentRight;
    count.textColor=[UIColor whiteColor];
    count.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    UIImageView *cover=[cell viewWithTag:30];
    if(cover==nil)
    {
        cover=[[UIImageView alloc] initWithFrame:cell.bounds];
        cover.tag=30;
        
    }
    cover.contentMode=UIViewContentModeScaleAspectFill;
    
    
    NSArray *posts=[dic valueForKey:@"posts"];
    NSDictionary *post=[[NSDictionary alloc] init];
    for (NSDictionary *temp in posts) {
        if([RatingFilter Filter:temp])
        {
            post=temp;
            break;
        }
    }
    [cover sd_setImageWithURL:[post valueForKey:@"preview_url"] placeholderImage:[UIImage imageNamed:@"placehodler"]];
    if(CellModifyBlock!=nil)
    {
        CellModifyBlock(cell,indexPath,dic);
    }
    [cell addSubview:cover];
    [cell addSubview:count];
    [cell addSubview:name];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIDevice *device = [UIDevice currentDevice] ;
    if(isPad)
    {
        if(device.orientation==UIDeviceOrientationLandscapeLeft||device.orientation==UIDeviceOrientationLandscapeRight)
        {
            return CGSizeMake(WideWidth,WideHeight);
        }
        else
        {
            return CGSizeMake(StandWidth,StandHeight);
        }
        
    }
    else
    {
        return CGSizeMake((width-10)/2, ((width-10)/2)/0.8);
    }
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    if(isPad)
    {
        return 20;
    }
    else
    {
        return 10;
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(isPad)
    {
        return 20;
    }
    else
    {
        return 10;
    }
}


@end
