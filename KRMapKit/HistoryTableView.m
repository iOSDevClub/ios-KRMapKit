//
//  HistoryTableView.m
//  KRMapKit
//
//  Created by Lai Wen Yu on 13/2/25.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "HistoryTableView.h"

@interface HistoryTableView ()

@end

@implementation HistoryTableView

@synthesize infoListClass;
@synthesize defaultUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [infoListClass getAllCoordinate];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(returnMapView)];
    infoListClass = [[InformationList alloc] init];
    
    //NSLog(@"infoListClass.results:%d", [infoListClass.results count]);
    
    [infoListClass getAllCoordinate];
    
    defaultUser = [NSUserDefaults standardUserDefaults];
    
    /*印出每一天以及每天紀錄的資料
    for (int i=0;i<[infoListClass.results count];i++){
        
        [defaultUser setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        
        NSLog(@"%d",[[defaultUser objectForKey:@"index"] intValue]);
        
        [infoListClass getAllCoordinate];
        
        NSLog(@"infoListClass.results: %@",[infoListClass.results objectAtIndex:i]);
        
        NSLog(@"infoListClass.infoListObject count: %d",[infoListClass.infoListObject count]);
    }
     */
}

-(void) returnMapView
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//計算每天的座標加到多少的number
-(int) getCoordinateTotalNumber
{
    totalNumber = 0;
    
    //取出infoListObject
    [infoListClass getAllCoordinate];
        
    //跑回圈並判斷內存的coordinate.number是多少
    for (int i=0;i<[infoListClass.infoListObject count];i++){
        infoListClass.coordinate = [infoListClass.infoListObject objectAtIndex:i];
        
        //NSLog(@"infoListClass.coordinate:%d", [infoListClass.coordinate.number intValue]);
        //若infoListClass.coordinate.number intValue + 1 > saveNumber的話
        if (([infoListClass.coordinate.number intValue]+1) > totalNumber){
            //saveNumber等於infoListClass.coordinate.number intValue+1, 這樣就能讓saveNumber永遠大於內存的coordinate.number
            
            totalNumber = [infoListClass.coordinate.number intValue]+1;
            
           // NSLog(@"saveNumber:%d",totalNumber);
        }
    }
    
    return totalNumber;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [infoListClass.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    infoListClass.infoListData = [infoListClass.results objectAtIndex:indexPath.row];
    
    [defaultUser setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%04d-%02d-%02d",[infoListClass.infoListData.year intValue],
                                                                       [infoListClass.infoListData.month intValue],
                                                                       [infoListClass.infoListData.day intValue]];
    
    [self getCoordinateTotalNumber];
    
    
    if ([infoListClass.infoListObject count] == 0){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total is 0"];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total is %d", totalNumber-1];
    }

    return cell;
}

//要使用self.editButtonItem事件的話, 必需實作此method
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//在self.editButtonItem中出現的按鈕事件
-(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //判斷為刪除按鈕
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //刪除使用者選擇的資料, 並對應到infoListData資料庫
        [infoListClass deleteInfoListDataPath:indexPath.row];
        //重新載入tableView
        [self.tableView reloadData];
        
        /* 印出infoListData內的資料
        for (int i=0;i<[infoListClass.results count];i++){
            NSLog(@"重新命名的index:%@",[[infoListClass.results objectAtIndex:i] valueForKey:@"index"]);
        }
         */
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableView *detail = [[DetailTableView alloc] init];
    
    [defaultUser setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
    
    detail.selectIndex = indexPath.row;
    
    [self getCoordinateTotalNumber];
    
    detail.coordinateNumber = totalNumber;
    
    if (![infoListClass.infoListObject count] == 0){
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
