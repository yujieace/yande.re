//
//  CollectionImageCell.m
//  yande.re
//
//  Created by 於杰 on 2018/10/4.
//  Copyright © 2018 hnzc. All rights reserved.
//

#import "CollectionImageCell.h"
#import <Masonry.h>
#import "GradientView.h"
@implementation CollectionImageCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    GradientView *gradientView = [[GradientView alloc] initWithFrame:CGRectZero];
    CAGradientLayer *layer = [gradientView getLayer];
    layer.colors =@[(__bridge id)[UIColor colorWithWhite:0 alpha:0.7].CGColor,
                    (__bridge id)[UIColor colorWithWhite:0 alpha:0].CGColor];
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(0, 0);
    [self.contentView addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@35);
    }];
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initWithFrame:self.frame];
}

@end
