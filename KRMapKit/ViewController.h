//
//  ViewController.h
//  KRMapKit
//
//  ilovekalvar@gmail.com
//
//  Created by Kuo-Ming Lin on 12/11/25.
//  Copyright (c) 2012年 Kuo-Ming Lin. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InformationList.h"
#import "AppDelegate.h"
#import "HistoryTableView.h"
#import "NavigationViewController.h"
#import "BookMarkTableView.h"

#define GPSTimer 1.0f                   //定位時間
#define ToolBar1AnimationIsHidden 0     //ToolBar動畫向下翻轉
#define ToolBar1AnimationNoHidden 1     //ToolBar動畫向上翻轉

@class SelfMKAnnotationProtocol;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,
                                              UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;             //GPS 管理器
    MKPolyline *routeLine;                          //路線
    MKPolylineView *routeLineView;                  //出現出線的view
    NSTimer *gpsTimer;                              //定位的計時器
    UIActivityIndicatorView *busy,*save;            //載入地圖和記錄路競時的特效動畫 View
    NSUserDefaults *defaultUser;                    //view與view傳值用的
    BOOL setup, isSave, stopScroll;                 //啟動設定的開關, 記錄開關
    int saveCount, saveNumber, routeCount;          //記錄次數,筆數,路線次數
    NSDateComponents *dateComp;                     //取得日期和時間
    NSString *currentAddress;                       //取得目前地址
    InformationList *infoListClass;                 //All Information List class
    AppDelegate *appDelegate;                       //AppDelegate 協定
    HistoryTableView *historyTableView;             //歷史資料的tableView
    NSMutableArray *latitudeArray, *longitudeArray, *addressArray, *nameArray, *countArray; //緯度、經度、地址、名稱、次數的Array
    UITextField *nameTextField;                     //在BookMark下輸入自訂名撐
    float tempLatitude, tempLongitude;              //在BookMark時, 取得使用者所選擇的緯度、經度
    NSString *tempAddress;                          //在BookMark時, 取得使用者所選擇的地址
    UIAlertView *bookMarkAlertView;
    int pinCount;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;                        //地圖
@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPolylineView *routeLineView;
@property (nonatomic, retain) NSTimer *gpsTimer;
@property (nonatomic, retain) NSUserDefaults *defaultUser;
@property (nonatomic, retain) IBOutlet UIView *containerView;                   //裝tool bar的views
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar1, *toolBar2;          //畫面的tool bar
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton, *subButton;  //增加和減少選擇座標
@property (nonatomic, retain) IBOutlet UISlider *routeSlider;                   //可滑動選擇座標
@property (nonatomic, retain) IBOutlet UILabel *routeTotalLabel;                //顯示路線座標的次數
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveHistoryButton;      //記錄路徑軌跡按鈕
@property (nonatomic, retain) IBOutlet UITextView *infoTextView;                //顯示時間,經度,緯度,地址
@property (nonatomic, retain) UIButton *restoreButton;                          //恢復infoTextView高度的按鈕
@property (nonatomic, strong) NSDateComponents *dateComp;
@property (nonatomic, strong) InformationList *infoListClass;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) HistoryTableView *historyTableView;

//更新區域位置
-(void)updateReginForLocation:(CLLocation *)newLocation keepSpan:(BOOL)keepSpan;
//新增地圖標記
-(void)addAnnotationsForMapView:(MKMapView *)theMapView
                    andLatitude:(float)latitude
                   andLongitude:(float)longitude
                       andTitle:(NSString *)title
                   withSubtitle:(NSString *)subtitle;
//記錄路徑軌跡
-(IBAction) saveHistoryAction:(id) sender;
//取得本地日期和時間
+(NSDateComponents *) getCurrnetDate;
//呼叫歷史資料的tableView
-(IBAction) callHistoryTableView:(id) sender;
//移除地圖上的路線
-(IBAction) removeMapViewOverlay:(id) sender;
//滑動方式可快速選擇座標
-(IBAction) slideDisplayCoordinate:(id) sender;
//按鈕方式選擇座標
-(IBAction) clickDisplayCoordinate:(id) sender;
//將座標加入我的最愛
-(IBAction) addCoordinateToBookMark:(id) sender;
//呼叫導航的NavigationViewController
-(IBAction) callNavigationViewController:(id) sender;
//呼叫BookMark tableView 頁面, 可查看目前所有的BookMark
-(IBAction) callBookMarkInformationTableView:(id) sender;

@end

