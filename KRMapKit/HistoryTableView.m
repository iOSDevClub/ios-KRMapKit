//
//  HistoryTableView.m
//  KRMapKit
//
//  Created by Lai Wen Yu on 13/2/25.
//  Copyright (c) 2013年 Wayne Lai. All rights reserved.
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
    
    /*  印出每一天以及每天紀錄的資料
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
