//
//  TagsCell.m
//  yande.re
//
//  Created by hnzc on 16/7/12.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "TagsCell.h"
#import <Masonry.h>
@implementation TagsCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    self.backgroundColor=[UIColor clearColor];
    _title=[[UILabel alloc] init];
    _title.textColor=[UIColor whiteColor];
    _title.textAlignment=NSTextAlignmentCenter;
    [self sizeToFit];
    [self addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(8);
        make.top.equalTo(self).offset(5);
        make.trailing.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, rect.size.width-4, rect.size.height-4) cornerRadius:8];
    [[UIColor whiteColor] setStroke];
    [path setLineWidth:0.5];
    [path stroke];
}
@end
