//
//  TableDelegate.h
//  yande.re
//
//  Created by YuJie on 16/5/18.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tagDidTaped)(NSIndexPath *indexPath,NSDictionary *tag);
@interface TableDelegate : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    tagDidTaped tagBlock;
}
@property (nonatomic,strong) NSMutableArray *Source;
-(instancetype)init;
-(void)SettagBlock:(tagDidTaped)block;
@end
