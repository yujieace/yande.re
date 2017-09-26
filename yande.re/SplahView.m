//
//  SplahView.m
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "SplahView.h"
#import "RatingFilter.h"
#import "TagsManager.h"
#define POSTCACHE [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/POST.plist"]
@implementation SplahView
-(void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSData *data=[NSData dataWithContentsOfFile:POSTCACHE];
    if(data==nil)
    {
        NSMutableArray *marry=[[NSMutableArray alloc] init];
        NSMutableDictionary *shared=[Singleton GetSharedData];
        [shared setObject:marry forKey:@"Source"];
        
    }
    else
    {
        NSMutableArray *marry=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary *shared=[Singleton GetSharedData];
        [shared setObject:marry forKey:@"Source"];
    }

    
    [self performSegueWithIdentifier:@"toMain" sender:self];
}




@end
