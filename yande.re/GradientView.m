//
//  GradientView.m
//  yande.re
//
//  Created by 於杰 on 2018/10/4.
//  Copyright © 2018 hnzc. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

+(Class)layerClass{
    return [CAGradientLayer class];
}

-(CAGradientLayer *)getLayer{
    return (CAGradientLayer *)self.layer;
}
@end
