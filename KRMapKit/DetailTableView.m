//
//  DetailTableView.m
//  KRMapKit
//

#import "DetailTableView.h"
#import "RouteClass.h"

@interface DetailTableView ()

@end

@implementation DetailTableView

@synthesize infoListClass;
@synthesize selectIndex, coordinateNumber;
@synthesize oldDataArray, allDataArray, totalCountArray;
@synthesize defaultUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(returnHistoryTableView)];
    infoListClass = [[InformationList alloc] init];
    
    //確保使用者點選的日期對應到資料庫裡面的判斷式
    for (int i=0;i<[infoListClass.results count];i++){
        infoListClass.infoListData = [infoListClass.results objectAtIndex:i];
        
        if ([infoListClass.infoListData.index intValue] == selectIndex){
            infoListClass.infoListData = [infoListClass.results objectAtIndex:i];
            break;
        }
    }

    //NSLog(@"selectIndex:%d",selectIndex);
    //NSLog(@"result:%@",infoListClass.results);
    
    //取出資料庫的infoListObject
    [infoListClass getAllCoordinate];
    
    oldDataArray = [[NSMutableArray alloc] init];
    allDataArray = [[NSMutableArray alloc] init];
    totalCountArray = [[NSMutableArray alloc] init];
    
    //將infoListClass.infoListObject copy到oldDataArray第一個object (因為infoListClass.infoListObject只是一個object)
    oldDataArray = [[NSMutableArray arrayWithObject:infoListClass.infoListObject] mutableCopy];
    //所以印出oldDataArray的話, count都是1
    //NSLog(@"oldDataArray:%d", [oldDataArray count]);
    
    //將所有的資料重新排序
    [self arrangementAllCoordinate];
    
    /* 印出當日所有的coordinate data
    for (int i=0;i<[allDataArray count];i++){
        NSLog(@"number:%d count:%d %02d:%02d:%02d",[[[allDataArray objectAtIndex:i] valueForKey:@"number"] intValue],
                                    [[[allDataArray objectAtIndex:i] valueForKey:@"count"] intValue],
                                    [[[allDataArray objectAtIndex:i] valueForKey:@"hour"] intValue],
                                    [[[allDataArray objectAtIndex:i] valueForKey:@"minute"] intValue],
                                    [[[allDataArray objectAtIndex:i] valueForKey:@"second"] intValue]);
    }
     */
}

//返回到HistoryTableView
-(void) returnHistoryTableView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//將所有的資料重新排序
-(void) arrangementAllCoordinate
{
    //印出當日全部記錄資料的總數, 方便確認迴圈需跑幾次
    //NSLog(@"infoListClass.infoListObject count:%d",[infoListClass.infoListObject count]);
    
    BOOL isFinish = FALSE, isStop = FALSE;
    int tempNumber = 1;
    int tempCount = 1;
    int totalCount = 0;
    
    //判斷每一個Number需跑幾次的count
    while (!isStop) {
        for (int i=0;i<[infoListClass.infoListObject count];i++){
            infoListClass.coordinate = [infoListClass.infoListObject objectAtIndex:i];
            
            if (tempNumber == [infoListClass.coordinate.number intValue]){
                
                //NSLog(@"number:%d count:%d", [infoListClass.coordinate.number intValue], [infoListClass.coordinate.count intValue]);
                totalCount++;
                //NSLog(@"totalCount:%d", totalCount);
            }
        }
        if (tempNumber <= coordinateNumber){
            [totalCountArray addObject:[NSNumber numberWithInt:totalCount]];
            tempNumber++;
            totalCount = 0;
            //totalCountArray的最後一個object若是為0, 就代表已結束計數totalCount
            if ([[totalCountArray lastObject] intValue] == 0)
                isStop = TRUE;
        }else{
            isStop = TRUE;
        }
    }
    
    //NSLog(@"%@",totalCountArray);
    //取得totalCountArray時, 兩個變數初始為1
    tempNumber = 1;
    tempCount = 1;
    //利用j進行totalCountArray對應的index
    int j = 0;
    
    //利用迴圈讓每一個number的count由小到大的排列
    while (!isFinish) {
        
        for (int i=0;i<[infoListClass.infoListObject count];i++){
            infoListClass.coordinate = [infoListClass.infoListObject objectAtIndex:i];
            
            //NSLog(@"number:%d count:%d", [infoListClass.coordinate.number intValue], [infoListClass.coordinate.count intValue]);
            //number和count由小到大開使排列
            if ([infoListClass.coordinate.number intValue] == tempNumber &&
                [infoListClass.coordinate.count intValue] == tempCount){
                
                //NSLog(@"%@", [[oldDataArray objectAtIndex:0] objectAtIndex:i]);
                //條件成立時, allDataArray將object加入
                [allDataArray addObject:[[oldDataArray objectAtIndex:0] objectAtIndex:i]];
                //tempCount+1
                tempCount++;
                
                //NSLog(@"tempCount:%d", tempCount);
                
                //若tempCount大於totalCountArray裡相對應的值, 代表此number已重新拍序完成, 再進行下一個Number的排序 , 
                if (tempCount > [[totalCountArray objectAtIndex:j] intValue]){
                    //tempCount需為1
                    tempCount = 1;
                    //tempNumber+1
                    tempNumber++;
                    //j+1
                    j++;
                    
                    //若j+1等於totalCountArray count的話, 就代表已重新排序過
                    if (j+1 == [totalCountArray count]){
                        isFinish = TRUE;
                        //NSLog(@"%@",allDataArray);
                    }
                }
            }
        }
    }
    
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
    return coordinateNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    //第一個迴圈 -- 取出number和第一個count
    for (int i=0;i<[infoListClass.infoListObject count];i++){
        infoListClass.coordinate = [infoListClass.infoListObject objectAtIndex:i];
        
        if ([infoListClass.coordinate.number intValue] == indexPath.row+1){
        
            //NSLog(@"tempCount:%d",tempCount);
            if ([infoListClass.coordinate.count intValue] == 1){
                cell.textLabel.text = [NSString stringWithFormat:@"路線:%d",[infoListClass.coordinate.number intValue]];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"起點:%02d-%02d-%02d", [infoListClass.coordinate.hour intValue],
                                             [infoListClass.coordinate.minute intValue],
                                             [infoListClass.coordinate.second intValue]];
            }
            //NSLog(@"count:%d",[[infoListClass.coordinate valueForKey:@"count"] intValue]);
        }
    }
    
    //第二個迴圈 -- 取出number和第最後一個count
    for (int i=0;i<[infoListClass.infoListObject count];i++){
        infoListClass.coordinate = [infoListClass.infoListObject objectAtIndex:i];
        
        if ([infoListClass.coordinate.number intValue] == indexPath.row+1){

            //NSLog(@"tempCount:%d",tempCount);            
            if ([infoListClass.coordinate.count intValue] == [[totalCountArray objectAtIndex:indexPath.row] intValue]){
                cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@" ~ 終點:%02d-%02d-%02d",
                                             [infoListClass.coordinate.hour intValue],
                                             [infoListClass.coordinate.minute intValue],
                                             [infoListClass.coordinate.second intValue]];
            }
            //NSLog(@"count:%d",[[infoListClass.coordinate valueForKey:@"count"] intValue]);
        }
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
    defaultUser = [NSUserDefaults standardUserDefaults];
    //暫存使用者選擇座標資料Array
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    //計算多少座標
    int coordinateCount = 0;
    
    for (int i=0;i<[allDataArray count];i++){
        //判斷使用者選擇的index, 將座標資料從allDataArray copy出來
        if([[[allDataArray objectAtIndex:i] valueForKey:@"number"] intValue] == indexPath.row+1){
            //NSLog(@"%d",[[[allDataArray objectAtIndex:i] valueForKey:@"number"] intValue]);
            
            //[newArray addObject:[allDataArray objectAtIndex:i]];
            
            //利用RouteClass解析座標資料
            RouteClass *route = [[RouteClass alloc] init];
            route.address = [[allDataArray objectAtIndex:i] valueForKey:@"address"];
            route.hour = [[allDataArray objectAtIndex:i] valueForKey:@"hour"];
            route.latitude = [[allDataArray objectAtIndex:i] valueForKey:@"latitude"];
            route.longitude = [[allDataArray objectAtIndex:i] valueForKey:@"longitude"];
            route.minute = [[allDataArray objectAtIndex:i] valueForKey:@"minute"];
            route.number = [[allDataArray objectAtIndex:i] valueForKey:@"number"];
            route.second = [[allDataArray objectAtIndex:i] valueForKey:@"second"];
            route.count = [[allDataArray objectAtIndex:i] valueForKey:@"count"];
            
            //newArray存入每一個route object
            [newArray addObject:route];
            //計算座標的count++
            coordinateCount ++;
        }
    }
    
    //無資料的話直接return
    if (coordinateCount == 0)
        return;
    
    //因為要用NSUserDefault傳newArray回到mapView, 所以必需將newArray做encoded的動作
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:newArray];
    //encoded後再利用NSUserdefault傳回mapView
    [defaultUser setObject:encodedData forKey:@"RouteArray"];
    //儲存傳回的筆數有多少筆
    [defaultUser setObject:[NSNumber numberWithInt:coordinateCount] forKey:@"coordinateCount"];
    
    [newArray removeAllObjects];
    encodedData = nil;
    
    //發出notification, 讓mapView秀出路線
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRoute" object:self];
    //返回mapView
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
