//
//  NavigationViewController.m
//  KRMapKit
//
//  wing50kimo@gmail.com
//
//  Created by Wayne Lai on 2013/01/01.
//  Copyright (c) 2013年 Wayne Lai. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

@synthesize isSelect;
@synthesize nowLatitude, nowLongitude;
@synthesize startPoint, endPoint;
@synthesize bookMarkResults;
@synthesize sourcePicker;
@synthesize startPlace, endPlace;
@synthesize nowButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableArray *) array
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bookMarkResults = [[NSMutableArray alloc] initWithArray:array];
        
        //NSLog(@"bookMarkResult:%@", [[bookMarkResults objectAtIndex:0] valueForKey:@"name"]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始滾輪
    sourcePicker.delegate = self;
    sourcePicker.showsSelectionIndicator = YES;
    [sourcePicker selectRow:[bookMarkResults count] inComponent:0 animated:YES];
    [sourcePicker selectRow:[bookMarkResults count] inComponent:1 animated:YES];
    
    isSelect = FALSE;
    
    startPoint = [[NSMutableArray alloc] init];
    endPoint = [[NSMutableArray alloc] init];
    
    //nowLatitude = 0.0f;
    //nowLongitude = 0.0f;
    NSLog(@"%f %f", nowLatitude, nowLongitude);
}

#pragma UITextField delegate

//使用者點選textfield的時候, 讓keyboard不彈出
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0){
        [startPlace resignFirstResponder];
    }
    else if (textField.tag == 1){
        [endPlace resignFirstResponder];
    }
}

#pragma UIPickerView delegate

//滾輪欄位
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //分別為起點和終點兩個欄位
    return 2;
}

//滾輪項目
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //將bookMark的資料筆數代入滾輪會出現的資料
    return [bookMarkResults count];
}

//滾輪資料
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //將bookMark的資料代入滾輪的欄位
    return [[bookMarkResults objectAtIndex:row] valueForKey:@"name"];
}

//滾輪的第一個欄位代入startPlace.text、滾輪第二個欄位代入endPlace.text
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //清空startPoint array
    [startPoint removeAllObjects];
    //清空endPoint array
    [endPoint removeAllObjects];
    
    //如果使用者按了目前位置按鈕的話, 滾輪第一欄位無作用
    if (isSelect == FALSE){
        //終點TextField顯示滾輪1的名稱
        startPlace.text = [NSString stringWithFormat:@"%@", [[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:0]]
                                                                                valueForKey:@"name"]];
        //startPoint array 依序加入使用者選擇的名稱, 緯度, 經度 
        [startPoint addObject:[[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"]];
        [startPoint addObject:[[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"latitude"]];
        [startPoint addObject:[[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"longitude"]];
    }
    
    //終點TextField顯示滾輪2的名稱
    endPlace.text = [NSString stringWithFormat:@"%@", [[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:1]]
                                                                          valueForKey:@"name"]];
    //endPoint array 依序加入使用者選擇的名稱, 緯度, 經度 
    [endPoint addObject:[[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:1]] valueForKey:@"name"]];
    [endPoint addObject:[[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:1]] valueForKey:@"latitude"]];
    [endPoint addObject:[[bookMarkResults objectAtIndex:[pickerView selectedRowInComponent:1]] valueForKey:@"longitude"]];
}

-(IBAction) getNowCoordinate:(id) sender
{
    //清空startPoint array
    [startPoint removeAllObjects];
    
    switch ([sender tag]) {
        case 0:
            [startPlace setText:@"目前位置"];
            [nowButton setTag:1];
            [nowButton setTitle:@"取消" forState:UIControlStateNormal];
            isSelect = TRUE;
            
            //startPoint array 依序加入目前位置, 目前緯度, 目前經度 
            [startPoint addObject:[NSString stringWithString:startPlace.text]];
            [startPoint addObject:[NSNumber numberWithFloat:nowLatitude]];
            [startPoint addObject:[NSNumber numberWithFloat:nowLongitude]];
            
            //NSLog(@"%@ %@ %@", [startPoint objectAtIndex:1], [startPoint objectAtIndex:2], [startPoint objectAtIndex:0]);
            break;
        case 1:
            [startPlace setText:@""];
            [nowButton setTag:0];
            [nowButton setTitle:@"目前位置" forState:UIControlStateNormal];
            isSelect = FALSE;
            break;
        default:
            break;
    }
    
}

//外開官方 Apple Maps App 進行路徑規劃。
//任二點導航
-(IBAction)anywhereDirection:(id)sender
{
    CLLocationCoordinate2D startGPSLocation;
    startGPSLocation.latitude  = [[startPoint objectAtIndex:1] floatValue];
    startGPSLocation.longitude = [[startPoint objectAtIndex:2] floatValue];
 
    CLLocationCoordinate2D endGPSLocation;
    endGPSLocation.latitude  = [[endPoint objectAtIndex:1] floatValue];
    endGPSLocation.longitude = [[endPoint objectAtIndex:2] floatValue];
    
    //啟動任二點的導航路徑規劃
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving,
                                                                         MKLaunchOptionsDirectionsModeKey, nil];
    //顯示起點的名稱
    MKPlacemark *place1 = [[MKPlacemark alloc] initWithCoordinate:startGPSLocation addressDictionary:nil];
    MKMapItem *destination1 = [[MKMapItem alloc] initWithPlacemark:place1];
    destination1.name = [startPoint objectAtIndex:0];
    
    //顯示終點的名稱
    MKPlacemark *place2 = [[MKPlacemark alloc] initWithCoordinate:endGPSLocation addressDictionary:nil];
    MKMapItem *destination2 = [[MKMapItem alloc] initWithPlacemark:place2];
    destination2.name = [endPoint objectAtIndex:0];
    
    NSLog(@"%@ %@ %@", [startPoint objectAtIndex:1], [startPoint objectAtIndex:2], [startPoint objectAtIndex:0]);
    NSLog(@"%@ %@ %@", [endPoint objectAtIndex:1], [endPoint objectAtIndex:2], [endPoint objectAtIndex:0]);
    
    //陣列第 1 個為出發地點，第二個為導航目的地
    NSArray *items = [[NSArray alloc] initWithObjects:destination1, destination2, nil];
    
    //導航
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

//返回ViewController
-(IBAction) backToViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
