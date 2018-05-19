//
//  ADImageViewController.h
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 hnzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWPhotoBrowser.h>
@interface ADImageViewController : MWPhotoBrowser
@property (nonatomic,strong) NSArray *imageList;
-(void)setCurrentPhotoIndex:(NSUInteger)index;
@end
