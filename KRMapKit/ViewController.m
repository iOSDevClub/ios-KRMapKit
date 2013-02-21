//
//  ViewController.m
//  KRMapKit
//
//  ilovekalvar@gmail.com
//
//  Created by Kuo-Ming Lin on 12/11/25.
//  Copyright (c) 2012年 Kuo-Ming Lin. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MKMapItem.h>
#import "KRAnnotationProtocol.h"

@interface ViewController(fixPrivate)



@end

@implementation ViewController(fixPrivate)



@end


@implementation ViewController

@synthesize mapView;
@synthesize latitudeLabel;
@synthesize longitudeLabel;

-(void) viewDidLoad{
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
    //開始定位
    [locationManager startUpdatingLocation];
    //停止定位
    //[locationManager stopUpdatingLocation];
    //設定當使用者的位置超出 X 公尺後才呼叫其他定位方法 :: 預設為 kCLDistanceFilterNone
    locationManager.distanceFilter = 10.0f;
    
    //顥示當前緯 / 經度
    CLLocation *location = locationManager.location;
    latitudeLabel.text   = [NSString stringWithFormat:@"%lf", location.coordinate.latitude];
    longitudeLabel.text  = [NSString stringWithFormat:@"%lf", location.coordinate.longitude];
    
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
    
    //設定區域至 MapView 裡
    mapView.region = centerRegion;
    //設定標記
    [self addAnnotationsForMapView:mapView
                       andLatitude:24.136845
                      andLongitude:120.685009
                          andTitle:@"台中火車站"
                      withSubtitle:@"火車頭"];
    
    //設定標記
    [self addAnnotationsForMapView:mapView
                       andLatitude:24.155006
                      andLongitude:120.662956
                          andTitle:@"台中 SOGO"
                      withSubtitle:@"旁邊有老虎城"];
    
    [super viewDidLoad];
    
    
    /*
     * @hello Clone.
     */
    
}

#pragma IBActions
/*
 * 外開官方 Apple Maps App 進行路徑規劃。
 */
//目前位置導航
-(IBAction)currentDirection:(id)sender{
    /*
     * 到台中火車站
     */
    CLLocationCoordinate2D firstGPSLocation;
    firstGPSLocation.latitude  = 24.136845;
    firstGPSLocation.longitude = 120.685009;
    MKPlacemark *place1 = [[MKPlacemark alloc] initWithCoordinate:firstGPSLocation addressDictionary:nil];
    MKMapItem *destination1 = [[MKMapItem alloc] initWithPlacemark:place1];
    destination1.name = @"台中火車站";
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    /*
     * 啟動目前位置的導航路徑規劃
     */
    [destination1 openInMapsWithLaunchOptions:options];
}

//任二點導航
-(IBAction)anywhereDirection:(id)sender{
    /*
     * 當前位置
     */
//    CLLocationCoordinate2D currentGPSLocation;
//    currentGPSLocation.latitude  = locationManager.location.coordinate.latitude;
//    currentGPSLocation.longitude = locationManager.location.coordinate.longitude;
//    MKPlacemark *place0 = [[MKPlacemark alloc] initWithCoordinate:currentGPSLocation addressDictionary:nil];
//    MKMapItem *destination0 = [[MKMapItem alloc] initWithPlacemark:place0];
//    destination0.name = @"當前位置";
    /*
     * 台中火車站
     */
    CLLocationCoordinate2D firstGPSLocation;
    firstGPSLocation.latitude  = 24.136845;
    firstGPSLocation.longitude = 120.685009;
    //目的地的大頭針
    MKPlacemark *place1 = [[MKPlacemark alloc] initWithCoordinate:firstGPSLocation addressDictionary:nil];
    //目的地( destination )
    MKMapItem *destination1 = [[MKMapItem alloc] initWithPlacemark:place1];
    destination1.name = @"台中火車站";
    /*
     * 到台中 SOGO
     */
    CLLocationCoordinate2D secondGPSLocation;
    secondGPSLocation.latitude  = 24.155006;
    secondGPSLocation.longitude = 120.662956;
    MKPlacemark *place2 = [[MKPlacemark alloc] initWithCoordinate:secondGPSLocation addressDictionary:nil];
    MKMapItem *destination2 = [[MKMapItem alloc] initWithPlacemark:place2];
    destination2.name = @"台中 SOGO";
    /*
     * 啟動任二點的導航路徑規劃
     */
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey,
                             nil];
    //陣列第 1 個為出發地點，第二個為導航目的地
    NSArray *items = [[NSArray alloc] initWithObjects:
                      //destination0,
                      destination1,
                      destination2,
                      nil];
    //導航
    [MKMapItem openMapsWithItems:items launchOptions:options];
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
-(void)addAnnotationsForMapView:(MKMapView *)theMapView
                    andLatitude:(float)latitude
                   andLongitude:(float)longitude
                       andTitle:(NSString *)title
                   withSubtitle:(NSString *)subtitle{
    
    //宣告 GPS 定位的 2D 地圖物件
    CLLocationCoordinate2D mapCenter;
    //宣告自訂義的 Annotation (標記)物件
    KRAnnotationProtocol *krAnno = [[KRAnnotationProtocol alloc] init];
    //設定緯度
    mapCenter.latitude  = latitude;
    //設定經度
    mapCenter.longitude = longitude;
    //設定標記物件裡的 GPS 定位地圖物件
    krAnno.coordinate = mapCenter;
    //設定標記的標題
    krAnno.title = title;
    //設定標記的內容
    krAnno.subtitle = subtitle;
    //將標記加入地圖裡
    [theMapView addAnnotation:krAnno];
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

//使用地圖標記功能 : Annotation 註解/註釋/銓釋
-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //如果是現在的位置，就不要使用標記功能
    if( [[annotation title] isEqualToString:@"Current Location"] ){
        return nil;
    }
    
    static NSString *pinIdentifier = @"currentPin";
    
    //讓 Pin (標記元件) 是可以被重覆使用的
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    //如果 Pin 不存在
    if( pin == nil ){
        //初始化
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
    }
    
    //設定標記顏色
    pin.pinColor = MKPinAnnotationColorPurple;
    //標記拖拉動畫
    pin.animatesDrop = YES;
    //標記呼喚
    pin.canShowCallout = YES;
    
    //點選標記時，說明的小圖示右方是一個單箭頭按鈕 : Accessory 附加物件
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //pin.rightCalloutAccessoryView = UIButtonTypeCustom;
    
    return pin;
}





@end
