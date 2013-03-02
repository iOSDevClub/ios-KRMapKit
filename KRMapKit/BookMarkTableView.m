//
//  BookMarkTableView.m
//  KRMapKit
//
//  Created by Lai Wen Yu on 13/3/2.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "BookMarkTableView.h"

@interface BookMarkTableView ()

@end

@implementation BookMarkTableView

@synthesize infoListClass;
@synthesize editAlertView;
@synthesize editTextField;

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
                                                                                          action:@selector(returnMapView)];
    infoListClass = [[InformationList alloc] init];
    
    [infoListClass fetchBookMarkAllInformation];
    
    for (int i=0;i<[infoListClass.bookMarkResults count];i++){
        NSLog(@"%@ %@",[[infoListClass.bookMarkResults objectAtIndex:i] valueForKey:@"name"],
                       [[infoListClass.bookMarkResults objectAtIndex:i] valueForKey:@"address"]);
    }
}

-(void) returnMapView
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    return [infoListClass.bookMarkResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    infoListClass.bookMark = [infoListClass.bookMarkResults objectAtIndex:indexPath.row];
    
    //顯示名稱
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[infoListClass.bookMark valueForKey:@"name"]];
    //顯示地址
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[infoListClass.bookMark valueForKey:@"address"]];
    //編輯用的按鈕
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //用bookMarkPath暫存使用者選則的indexPath
    bookMarkPath = indexPath.row;
    //跳出編輯視窗
    editAlertView = [[UIAlertView alloc] initWithTitle:@"修改名稱"
                                               message:@""
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"Save", nil];
    [editAlertView show];
    //編輯視窗一跳出, 直接讓editTextField的keyboard彈出
    [editTextField becomeFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            //儲存使用者修改過的新名稱
            [infoListClass modifyBookMarkName:editTextField.text Path:bookMarkPath];
            //重新載入tableView
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

//自訂UIAlertView
-(void) willPresentAlertView:(UIAlertView *)alertView
{
    CGRect frame = editAlertView.frame;
    
    if (alertView == editAlertView){
        //設定alertView寬度和位置
        frame.origin.x = 20;
        frame.size.width = 280;
        //設定alertView高度和位置
        frame.origin.y -= 100;
        frame.size.height += 30;
        //alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alertView.frame = frame;
        
        for (UIView *view in self->editAlertView.subviews){
            if (view.tag == 1){
                //設定noButton frame
                CGRect noButton = CGRectMake(25, frame.size.height-50, 105, 30);
                view.frame = noButton;
            }
            else if (view.tag == 2){
                //設定yesButton frame
                CGRect yesButton = CGRectMake(152, frame.size.height-50, 105, 30);
                view.frame = yesButton;
            }
        }
    }
    
    editTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 50, 200, 31)];
    editTextField.borderStyle = UITextBorderStyleRoundedRect;
    editTextField.delegate = self;
    editTextField.placeholder = @"請輸入新名稱";
    editTextField.textAlignment = NSTextAlignmentLeft;
    editTextField.keyboardType = UIKeyboardTypeDefault;
    
    [alertView addSubview:editTextField];
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
        //刪除使用者選擇的資料, 並對應到BookMark資料庫
        [infoListClass deleteBookMarkDataPath:indexPath.row];
        //重新載入tableView
        [self.tableView reloadData];
        //印出BookMark內的資料
        for (int i=0;i<[infoListClass.bookMarkResults count];i++){
            NSLog(@"%@ %@",[[infoListClass.bookMarkResults objectAtIndex:i] valueForKey:@"name"],
                           [[infoListClass.bookMarkResults objectAtIndex:i] valueForKey:@"address"]);
        }
    }
}

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
