//
//  ViewController.m
//  KRMapKit
//
//  ilovekalvar@gmail.com
//  wing50kimo@gmail.com
//
//  Created by Kuo-Ming Lin & Wayne Lai on 2013/01/01.
//  Copyright (c) 2013年 Kuo-Ming Lin & Wayne Lai. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MKMapItem.h>
#import "KRAnnotationProtocol.h"
#import "KRAnnotationView.h"
#import "RouteClass.h"

@implementation ViewController

@synthesize mapView;
@synthesize routeLine, routeLineView;
@synthesize gpsTimer;
@synthesize defaultUser;
@synthesize containerView, toolBar1, toolBar2, addButton, subButton, routeSlider, routeTotalLabel;
@synthesize saveHistoryButton, dateComp, infoTextView, infoListClass, appDelegate;
@synthesize restoreButton;
@synthesize historyTableView;

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) receivesNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"showRoute"]) {
        //顯示路線
        [self showAllCoordinateOnMap];
        //toolBar切換的動畫
        [self toolBarAnimation:ToolBar1AnimationIsHidden];
        //停止gpsTimer
        [gpsTimer invalidate];
    }
}

//mapView定位初始
-(void) locationCurrentPlace
{
    //設定 MapView 的委派
    mapView.delegate          = self;
    //允許縮放地圖
    mapView.zoomEnabled       = YES;
    //允許捲動地圖
    mapView.scrollEnabled     = YES;
    //以小藍點顯示使用者目前的位置
    mapView.showsUserLocation = YES;
    //CLLocationManager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //設定精準度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    //開始定位
    [locationManager startUpdatingLocation];
    //停止定位
    //[locationManager stopUpdatingLocation];
    //設定當使用者的位置超出 X 公尺後才呼叫其他定位方法 :: 預設為 kCLDistanceFilterNone
    locationManager.distanceFilter = 10.0f;
}

-(void) viewDidLoad
{
    //mapView定位初始
    [self locationCurrentPlace];
    //顥示當前緯 / 經度
    CLLocation *location = locationManager.location;
    
    //初始infoListClass物件
    infoListClass = [[InformationList alloc] init];
    
    defaultUser = [NSUserDefaults standardUserDefaults];
    
    //判斷當天的日期是否已儲存過的flag
    BOOL isExist = NO;
    
    //取得當地日期時間
    dateComp = [ViewController getCurrnetDate];
    
    //textView 顯示:儲存次數, 年, 月, 日, 時, 分, 秒, 經度, 緯度, 地址
    [infoTextView setText:[infoTextView.text stringByAppendingFormat:@"%04d-%02d-%02d-%02d:%02d:%02d\n緯度: %f 經度: %f \n地址:\n",
                           dateComp.year, dateComp.month, dateComp.day, dateComp.hour, dateComp.minute, dateComp.second,
                           location.coordinate.latitude, location.coordinate.longitude]];
    
    //NSLog(@"%d%d%d",dateComp.year, dateComp.month, dateComp.day);
     
    //若無資料, 儲存當日的日期, index=0
    if ([infoListClass.results count] == 0){
        [infoListClass saveIndex:0 andYear:dateComp.year andMonth:dateComp.month andDay:dateComp.day];
        //暫存index
        [defaultUser setObject:infoListClass.infoListData.index forKey:@"index"];
        //儲存第一筆
        isExist = YES;
    }else{
        //判斷當天的日期是否已儲存過的方法
        for (int i=0;i<[infoListClass.results count];i++){
            infoListClass.infoListData = [infoListClass.results objectAtIndex:i];
            
            if ([infoListClass.infoListData.year intValue] == dateComp.year &&
                [infoListClass.infoListData.month intValue] == dateComp.month &&
                [infoListClass.infoListData.day intValue] == dateComp.day){
                //已存在
                isExist = YES;
                infoListClass.infoListData = [infoListClass.results objectAtIndex:i];
                break;
            }
        }
    }
    //當天日期已儲存過的話, 就取出當天的index以方便之後的引用
    if (isExist == YES){
        //暫存index
        [defaultUser setObject:infoListClass.infoListData.index forKey:@"index"];
        
        NSLog(@"index:%d",[[defaultUser objectForKey:@"index"] intValue]);
    }
    //當天日期無儲存過的話, 則儲存於資料庫, 並取出當天的index以方便之後的引用
    else if (isExist == NO){
        [infoListClass saveIndex:[infoListClass.results count] andYear:dateComp.year andMonth:dateComp.month andDay:dateComp.day];
        //暫存index
        [defaultUser setObject:infoListClass.infoListData.index forKey:@"index"];
        NSLog(@"%@", infoListClass.results);
    }
    
    //每秒更新時間和經度緯度的timer
    gpsTimer = [NSTimer scheduledTimerWithTimeInterval:GPSTimer target:self selector:@selector(dateTimer) userInfo:nil repeats:YES];
        
    //設定方向過濾方式
    locationManager.headingFilter = kCLHeadingFilterNone;
    //啟動指南針方向定位
    [locationManager startUpdatingHeading];
        
    //指定中心點為當前位置
    MKCoordinateRegion centerRegion;
    centerRegion.center.latitude  = location.coordinate.latitude;
    centerRegion.center.longitude = location.coordinate.longitude;
    
    //指定顯示區域範圍
    centerRegion.span.latitudeDelta  = 0.1;
    centerRegion.span.longitudeDelta = 0.1;
    
    //預設記錄為false
    isSave = FALSE;
    //預設停止划動infoTextView為false
    stopScroll = FALSE;
    //為infoTextView加入單擊的物件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    
    [singleTap setNumberOfTapsRequired:1];
    [self.infoTextView addGestureRecognizer:singleTap];
    
    //恢復infoTextView高度和位置的button
    restoreButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [restoreButton setFrame:CGRectMake(self.view.frame.size.width-40, 0, 30, 30)];
    [restoreButton addTarget:self action:@selector(restoreInfoTextViewHeight) forControlEvents:UIControlEventTouchUpInside];
    [restoreButton setHidden:YES];
    [infoTextView addSubview:restoreButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivesNotification:) name:@"showRoute" object:nil];
    
    [super viewDidLoad];
}

//單擊infoTextView讓尺寸變大
-(void) handleSingleTap
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    
    [restoreButton setHidden:NO];
    [infoTextView setFrame:CGRectMake(0, self.view.frame.size.height-130, 320, 130)];
    stopScroll = TRUE;
    [UIView commitAnimations];
}

//恢復infoTextView原本的位置
-(void) restoreInfoTextViewHeight
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    
    [restoreButton setHidden:YES];
    [infoTextView setFrame:CGRectMake(0, self.view.frame.size.height-65, 320, 65)];
    stopScroll = FALSE;
    [UIView commitAnimations];
}

#pragma My Methods
//更新顥示的視野
-(void)updateReginForLocation:(CLLocation *)newLocation keepSpan:(BOOL)keepSpan{
    MKCoordinateRegion theRegion;
    theRegion.center = newLocation.coordinate;
    if( !keepSpan ){
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta  = 0.1;
        theSpan.longitudeDelta = 0.1;
        theRegion.span = theSpan;
    }else{
        theRegion.span = mapView.region.span;
    }
    
    [mapView setRegion:theRegion animated:YES];
}

//新增地圖標記
-(void)addAnnotationForMapView:(MKMapView *)_theMapView
                      latitude:(float)_latitude
                     longitude:(float)_longitude
                         title:(NSString *)_theTitle
                      subtitle:(NSString *)_subtitle
{
    //宣告 GPS 定位的 2D 地圖物件
    //設定標記物件裡的 GPS 定位地圖物件
    CLLocationCoordinate2D mapCenter;
    //設定緯度
    mapCenter.latitude  = _latitude;
    //設定經度
    mapCenter.longitude = _longitude;
    //宣告自訂義的 Annotation (標記)物件
    KRAnnotationProtocol *krAnno = [[KRAnnotationProtocol alloc] initWithCoordinate:mapCenter
                                                                        customTitle:_theTitle
                                                                     customSubtitle:_subtitle];
    //設定圖片
    krAnno.leftImage      = [UIImage imageNamed:@"ele_author_small.png"];
    //將標記加入地圖裡
    [_theMapView addAnnotation:krAnno];
}

#pragma MKMapViewDelegate
//要開始定位使用者位置
-(void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    
}

//開始載入地圖時，顥示等待的動畫
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    if( busy == nil ){
        busy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        busy.frame = CGRectMake(120, 180, 80, 80);
        [self.view addSubview:busy];
    }
    busy.hidesWhenStopped = YES;
    [busy startAnimating];
}

//完全載入地圖後，停止動畫
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    [busy stopAnimating];
}

//使用者位置更新後，讓現在位置置中
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if( !setup ){
        setup = YES;
        //更新顥示的視野
        [self updateReginForLocation:userLocation.location keepSpan:NO];
    }else{
        setup = NO;
        [self updateReginForLocation:userLocation.location keepSpan:YES];
    }
}

/*
 * @ 使用地圖標記 Pin ( Annotation )
 *   - 動態加入大頭針
 *   - 反解譯取得經緯度
 */
-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    /*
     * @ 如果是現在的位置，就不要使用標記功能
     */
    if( [annotation isKindOfClass:[MKUserLocation class]] )
    {
        return nil;
    }
    //
    KRAnnotationProtocol *_krAnnotation = (KRAnnotationProtocol *)annotation;
    NSString *_reusePinId = @"_pinId";
    /*
     * @ Pin (標記元件) 是可以被重覆使用且客製化的
     *   - 這裡先試著取出「已經被定義且使用者 MapView 上的 Pin」，之後就重複使用該 Pin。
     *   - 原理跟 TableViewCell 的作動一樣。
     *
     * @ 原始為 MKPinAnnotationView ( 直接一個大頭針 View )
     *   而 MKAnnotationView 則是一個「點」的大頭針，兩者不同。
     *
     */
    KRAnnotationView *_krAnnotationView = (KRAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:_reusePinId];
    if( _krAnnotationView == nil )
    {
        _krAnnotationView = [[KRAnnotationView alloc] initWithAnnotation:_krAnnotation reuseIdentifier:_reusePinId];
    }
    //設定標記顏色
    //pin.pinColor = MKPinAnnotationColorPurple;
    //標記拖拉動畫
    //pin.animatesDrop = YES;
    //Callout 彈出註釋呼喚 ( Default is NO )
    _krAnnotationView.canShowCallout = YES;
    //可以拖拉
    //_krAnnotationView.draggable = YES;
    //點選標記時，說明的小圖示右方是一個單箭頭按鈕 : Accessory 附加物件
    _krAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //pin.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"大頭針左側小圖.png"]];
    return _krAnnotationView;
}

/*
 * @ 當 Pin ( 大頭針 ) 的右側箭頭被按下時
 */
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if( [view.annotation isKindOfClass:[KRAnnotationProtocol class]] )
    {
        KRAnnotationProtocol *_krAnnotation = (KRAnnotationProtocol *)view.annotation;
        NSString *_idIndex = _krAnnotation.idIndex;
        if( _idIndex )
        {
            //... 看該 ID 底下的內容 Detail
        }
    }
}

/*
 * @ 當選擇 Pin 時
 *   - 此時才執行客製化 Pin 內容的動作
 */
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if( [view isKindOfClass:[KRAnnotationView class]] )
    {
        KRAnnotationView *_krAnnotationView   = (KRAnnotationView *)view;
        KRAnnotationProtocol *_krAnnotation   = (KRAnnotationProtocol *)_krAnnotationView.annotation;
        _krAnnotationView.leftImageView = [[UIImageView alloc] initWithImage:_krAnnotation.leftImage];
        [_krAnnotationView makeCustomContent];
    }
}

//顯示地圖上歷史記錄的軌跡
-(MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayView *overlayView = nil;
    
    if (overlay == routeLine){
        if (nil == routeLineView){
            routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
            [routeLineView setFillColor:[UIColor redColor]];
            [routeLineView setStrokeColor:[UIColor redColor]];
            [routeLineView setLineWidth:2.5f];
        }
        return routeLineView;
    }
    return overlayView;
}

//代入座標並顯示出路徑
-(void) showAllCoordinateOnMap
{
    //decode, 使用者選擇的歷史路徑
    NSData *decodedData = [defaultUser objectForKey:@"RouteArray"];
    NSArray *decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
    
    //宣告輸入路線座標的陣列
    CLLocationCoordinate2D coordinateArray[[[defaultUser objectForKey:@"coordinateCount"] intValue]];
    //NSLog(@"coordinateCount:%d", [[defaultUser objectForKey:@"coordinateCount"] intValue]);
    
    //宣告暫存latitude、longitude、address、count array
    latitudeArray = [[NSMutableArray alloc] init];
    longitudeArray = [[NSMutableArray alloc] init];
    addressArray = [[NSMutableArray alloc] init];
    countArray = [[NSMutableArray alloc] init];
    
    //記錄座標的總數
    routeCount = [[defaultUser objectForKey:@"coordinateCount"] intValue];
    //畫面一回到mapView時先顯示座標的總數
    routeTotalLabel.text = [NSString stringWithFormat:@"%d", [[defaultUser objectForKey:@"coordinateCount"] intValue]];
    //設置routeSlider的最大值
    routeSlider.maximumValue = [[defaultUser objectForKey:@"coordinateCount"] intValue];
    //設置routeSlider的值
    routeSlider.value = [[defaultUser objectForKey:@"coordinateCount"] intValue];
    
    //取出存在RouteClass的資料
    for (RouteClass *route in decodedArray){
        //NSLog(@"count:%d latitude:%f, longitude:%f",[route.count intValue], [route.latitude doubleValue], [route.longitude doubleValue]);
        
        if ([route.count intValue] == 0)
            break;
        //儲存latitude的Array
        [latitudeArray addObject:route.latitude];
        //儲存longitude的Aray
        [longitudeArray addObject:route.longitude];
        //儲存address的Array
        [addressArray addObject:route.address];
        //儲存count的Array
        [countArray addObject:route.count];
    }
    
    //latitudeArray和longitudeArray各別帶入coordinateArray[]
    for (int i=0;i<[latitudeArray count]; i++) {
        coordinateArray[i] = CLLocationCoordinate2DMake([[latitudeArray objectAtIndex:i] doubleValue],
                                                        [[longitudeArray objectAtIndex:i] doubleValue]);
    }
    
    //路線物件帶入coordinateArray的值
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:[[defaultUser objectForKey:@"coordinateCount"] intValue]];
    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:routeLine];
    
    //在最後一個座標插入大頭針
    [self displayCoordinateWithPin:[[countArray lastObject] intValue]];
    
    //清除RouteArray
    [defaultUser setObject:NULL forKey:@"RouteArray"];
    
    //mapView向下的動畫
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    
    [mapView setFrame:CGRectMake(0, 77, 320, 318)];
    
    //對應4寸螢幕
    if ([[defaultUser objectForKey:@"4Inch"] isEqualToString:@"4Inch"]){
        [mapView setFrame:CGRectMake(0, 77, 320, 407)];
    }
    
    [UIView commitAnimations];
}

//記錄路徑軌跡
-(IBAction) saveHistoryAction:(id) sender
{
    if (isSave == FALSE){
        isSave = YES;
        [saveHistoryButton setTitle:@"記錄中..."];
        //轉吧～轉吧～
        save = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [save setFrame:CGRectMake(220, 8, 30, 30)];
        [save startAnimating];
        [toolBar1 addSubview:save];
        
        //儲存次數
        saveCount = 0;
        //取出coordinate所有的object
        [infoListClass getAllCoordinate];
        
        if ([infoListClass.infoListObject count] == 0){
            saveNumber = 1;
            return;
        }
        
        //跑回圈並判斷內存的coordinate.number是多少
        for (int i=0;i<[infoListClass.infoListObject count];i++){
            infoListClass.coordinate = [infoListClass.infoListObject objectAtIndex:i];
            
            //若infoListClass.coordinate.number intValue + 1 > saveNumber的話
            if (([infoListClass.coordinate.number intValue]+1) > saveNumber){
                //saveNumber等於infoListClass.coordinate.number intValue+1, 這樣就能讓saveNumber永遠大於內存的coordinate.number
                saveNumber = [infoListClass.coordinate.number intValue]+1;
                
                //NSLog(@"saveNumber:%d",saveNumber);
            }
        }
    }
    else if (isSave == YES){
        [saveHistoryButton setTitle:@"記錄"];
        isSave = FALSE;
        
        [save removeFromSuperview];
    }
}

//每秒更新一次日期和時間, 經度, 緯度, 地址
-(void) dateTimer
{
    //取得當地日期時間
    dateComp = [ViewController getCurrnetDate];
    
    //顥示當前緯 / 經度
    CLLocation *location = locationManager.location;
    
    if (isSave == FALSE){
        [infoTextView setText:@""];
        
        //textView 顯示:儲存次數, 年, 月, 日, 時, 分, 秒, 經度, 緯度, 地址
        [infoTextView setText:[infoTextView.text stringByAppendingFormat:@"%04d-%02d-%02d-%02d:%02d:%02d\n緯度: %f 經度: %f \n地址:\n",
                           dateComp.year, dateComp.month, dateComp.day, dateComp.hour, dateComp.minute, dateComp.second,
                           location.coordinate.latitude, location.coordinate.longitude]];
    }
    else if (isSave == YES){
        //儲存次數+1
        saveCount++;
        //textView 顯示:儲存次數, 年, 月, 日, 時, 分, 秒, 經度, 緯度, 地址
        [infoTextView setText:[infoTextView.text stringByAppendingFormat:@"(%d) %04d-%02d-%02d-%02d:%02d:%02d\n緯度: %f 經度: %f \n地址:\n",
                           saveNumber, dateComp.year, dateComp.month, dateComp.day, dateComp.hour, dateComp.minute, dateComp.second,
                           location.coordinate.latitude, location.coordinate.longitude]];
        
        if (stopScroll == FALSE){
            //取得textView高度範圍
            NSRange range = NSMakeRange(infoTextView.text.length-1, 1);
            //textView自動向下
            [infoTextView scrollRangeToVisible:range];
        }
        
        //儲存時間, 經度, 緯度, 次數
        [infoListClass saveInformationDataHour:dateComp.hour Min:dateComp.minute Sec:dateComp.second
                                          Addr:[NSString stringWithFormat:@"台中市 %d",saveCount]
                                         Count:saveCount Num:saveNumber
                                      Latitude:location.coordinate.latitude Longitude:location.coordinate.longitude];
        
        //NSLog(@"saveCount:%d",saveCount);
    }
    //NSLog(@"gpsTimer");
}

//取得本地日期和時間
+(NSDateComponents *) getCurrnetDate
{
    //建立日期型態
    NSDate *date = [NSDate date];
    
    //日期格式轉換
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit |
    NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComp = [calendar components:flag fromDate:date];
    
    return dateComp;
}

//呼叫路線歷史資料的tableView
-(IBAction) callHistoryTableView:(id) sender
{
    //停止gps timer
    [gpsTimer invalidate];
    
    historyTableView = [[HistoryTableView alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:historyTableView];
    
    //移除路線
    [self removeMapViewOverlay:sender];
    
    [self presentViewController:navigation animated:YES completion:NULL];
}

//移除地圖上的路線
-(IBAction) removeMapViewOverlay:(id) sender
{
    //mapView向上移動的動畫
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    
    [mapView setFrame:CGRectMake(0, 45, 320, 350)];
    
    //對應4寸螢幕
    if ([[defaultUser objectForKey:@"4Inch"] isEqualToString:@"4Inch"]){
        [mapView setFrame:CGRectMake(0, 45, 320, 440)];
    }
    
    [UIView commitAnimations];
    
    //移除mapView裡面所有的overlay
    for (id<MKOverlay> overlayToRemove in mapView.overlays){
        if ([overlayToRemove isKindOfClass:[overlayToRemove class]]){
            [mapView removeOverlay:overlayToRemove];
        }
    }
    
    //移除地圖上的overlays
    routeLine = nil;
    routeLineView = nil;
    [routeLineView removeFromSuperview];
    [mapView removeAnnotations:mapView.annotations];
 
    //toolBar切換的小動畫
    [self toolBarAnimation:ToolBar1AnimationNoHidden];
    
    [self locationCurrentPlace];
    
    //重新定位更新時間和經度緯度
    gpsTimer = [NSTimer scheduledTimerWithTimeInterval:GPSTimer target:self selector:@selector(dateTimer) userInfo:nil repeats:YES];
}

//toolbar切換的小動畫
-(void) toolBarAnimation:(int) action
{
    //CA動畫, type為立方體的翻轉方式
    CATransition *anim = [CATransition animation];
    [anim setDelegate:self];
    [anim setDuration:1.0f];
    [anim setType:@"cube"];
    
    //toolBar1 set hidden YES 的時候就往下翻
    if (action == 0){
        [anim setSubtype:kCATransitionFromBottom];
        [[containerView layer] addAnimation:anim forKey:@"nil"];
        [toolBar1 setHidden:YES];
    }
    //toolBar1 set hidden NO 的時候就往上翻
    else if (action == 1){
        [anim setSubtype:kCATransitionFromTop];
        [[containerView layer] addAnimation:anim forKey:@"nil"];
        [toolBar1 setHidden:NO];
    }
}

//滑動方式可快速選擇座標
-(IBAction) slideDisplayCoordinate:(UISlider *) sender
{
    routeCount = [sender value];
    
    if (routeCount <= 0){
        routeSlider.value = 1;
        return;
    }

    routeSlider.value = routeCount;
    routeTotalLabel.text = [NSString stringWithFormat:@"%.0f", routeSlider.value];
    //依據使用者選取的count,插入大頭針
    [self  displayCoordinateWithPin:routeCount];
}

//按鈕方式選擇座標
-(IBAction) clickDisplayCoordinate:(id) sender
{
    switch ([sender tag]) {
        case 3:
            routeCount--;
            
            if (routeCount <= 0){
                routeCount = 1;
                return;
            }
            break;
        case 5:
            routeCount++;
            
            if (routeCount > [[defaultUser objectForKey:@"coordinateCount"] intValue]){
                routeCount = [[defaultUser objectForKey:@"coordinateCount"] intValue];
                return;
            }
            break;
        default:
            break;
    }
    
    routeSlider.value = routeCount;
    routeTotalLabel.text = [NSString stringWithFormat:@"%d", routeCount];
    //依據使用者選取的count,插入大頭針
    [self  displayCoordinateWithPin:routeCount];
}

//依據使用者選取的count,插入大頭針
-(void) displayCoordinateWithPin:(int) count
{
    //先移除mapView上的大頭針
    [mapView removeAnnotations:mapView.annotations];
    
    float lat = 0.0, lon = 0.0;
    NSString *address;
    
    for (int i=0;i<[[defaultUser objectForKey:@"coordinateCount"] intValue];i++){
        
        if (count == [[countArray objectAtIndex:i] intValue]){
            lat = [[latitudeArray objectAtIndex:i] doubleValue];
            lon = [[longitudeArray objectAtIndex:i] doubleValue];
            address = [addressArray objectAtIndex:i];
            
            break;
        }
    }
    //插入大頭針
    [self addAnnotationForMapView:mapView
                         latitude:lat
                        longitude:lon
                            title:[NSString stringWithFormat:@"%d",count]
                         subtitle:address];
    
    tempLatitude = lat;
    tempLongitude = lon;
    tempAddress = address;
}

//將座標加入我的最愛
-(IBAction) addCoordinateToBookMark:(id) sender
{
    bookMarkAlertView = [[UIAlertView alloc] initWithTitle:@"BookMark!!"
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:@"NO"
                                         otherButtonTitles:@"YES", nil];
    [bookMarkAlertView show];

    [nameTextField becomeFirstResponder];
}

#pragma UIAlertView delegate

//自訂UIAlertView
-(void) willPresentAlertView:(UIAlertView *)alertView
{
    CGRect frame = bookMarkAlertView.frame;
    
    if (alertView == bookMarkAlertView){
        //設定alertView寬度和位置
        frame.origin.x = 20;
        frame.size.width = 280;
        //設定alertView高度和位置
        frame.origin.y -= 180;
        frame.size.height += 140;
        //alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alertView.frame = frame;
        
        for (UIView *view in self->bookMarkAlertView.subviews){
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
    
    //左方顯示的Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 115, 31)];
    nameLabel.text = @"名稱_";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addSubview:nameLabel];
    //讓使用者輸入自訂的名稱欄位
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 55, 200, 31)];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.delegate = self;
    nameTextField.placeholder = @"請輸入名稱";
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    [alertView addSubview:nameTextField];
    //顯示使用者選擇的緯度
    UILabel *latidtudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, 200, 31)];
    latidtudeLabel.text =[[NSString alloc] initWithFormat:@"緯度_%f", tempLatitude];
    latidtudeLabel.backgroundColor = [UIColor clearColor];
    latidtudeLabel.textColor = [UIColor whiteColor];
    latidtudeLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addSubview:latidtudeLabel];
    //顯示使用者選擇的經度
    UILabel *longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 200, 31)];
    longitudeLabel.text = [[NSString alloc] initWithFormat:@"經度_%f", tempLongitude];
    longitudeLabel.backgroundColor = [UIColor clearColor];
    longitudeLabel.textColor = [UIColor whiteColor];
    longitudeLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addSubview:longitudeLabel];
    //顯示使用者選擇的地址
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, 200, 31)];
    addressLabel.text = [[NSString alloc] initWithFormat:@"地址_%@", tempAddress];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addSubview:addressLabel];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            //儲存使用者選擇的名稱、座標、地址
            [infoListClass saveName:nameTextField.text Address:tempAddress Latitude:tempLatitude Longitude:tempLongitude];
            break;
        default:
            break;
    }
}

//namerTextField return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [nameTextField resignFirstResponder];
    
    return YES;
}

//呼叫導航的NavigationViewController
-(IBAction) callNavigationViewController:(id)sender
{
    NavigationViewController *navigation = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController"
                                                                                      bundle:[NSBundle mainBundle]
                                                                                        data:infoListClass.bookMarkResults];
    //將目前緯 / 經度直接代入NavigationViewController
    CLLocation *location = locationManager.location;

    navigation.nowLatitude = location.coordinate.latitude;
    navigation.nowLongitude = location.coordinate.longitude;
    
    navigation.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ([[defaultUser objectForKey:@"4Inch"] isEqualToString:@"4Inch"]){
        navigation = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController4Inch"
                                                                bundle:[NSBundle mainBundle]
                                                                  data:infoListClass.bookMarkResults];
    }
    
    [self presentViewController:navigation animated:YES completion:NULL];
}

//呼叫BookMark tableView頁面, 可查看目前所有的BookMark
-(IBAction) callBookMarkInformationTableView:(id)sender
{
    BookMarkTableView *bookMarkTableView = [[BookMarkTableView alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:bookMarkTableView];
    
    navigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:navigation animated:YES completion:NULL];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //移除latitudeArray內所有的object
    [latitudeArray removeAllObjects];
    //移除longitudeArray內所有的object
    [longitudeArray removeAllObjects];
    //移除addressArray內所有的object
    [addressArray removeAllObjects];
}

@end
