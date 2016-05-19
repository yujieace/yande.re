//
//  TableDelegate.m
//  yande.re
//
//  Created by hnzc on 16/5/18.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "TableDelegate.h"

@interface TableDelegate ()

@end

@implementation TableDelegate

-(instancetype)init
{
    self=[super init];
    _Source=[[NSMutableArray alloc] init];
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Source.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] init];
    }
    NSDictionary *dic=[_Source objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic valueForKey:@"name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)SettagBlock:(tagDidTaped)block
{
    tagBlock=block;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tagBlock!=nil)
    {
        tagBlock(indexPath,[_Source objectAtIndex:indexPath.row]);
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
