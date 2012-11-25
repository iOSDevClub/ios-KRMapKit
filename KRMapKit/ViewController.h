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

@class SelfMKAnnotationProtocol;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    //GPS 管理器
    CLLocationManager *locationManager;
    //載入地圖時的特效動畫 View
    UIActivityIndicatorView *busy;
    //啟動設定的開關
    BOOL setup;
}

//地圖
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
//緯度
@property (nonatomic, strong) IBOutlet UILabel *latitudeLabel;
//經度
@property (nonatomic, strong) IBOutlet UILabel *longitudeLabel;

//目前位置導航
-(IBAction)currentDirection:(id)sender;
//任二點導航
-(IBAction)anywhereDirection:(id)sender;
//更新區域位置
-(void)updateReginForLocation:(CLLocation *)newLocation keepSpan:(BOOL)keepSpan;
//新增地圖標記
-(void)addAnnotationsForMapView:(MKMapView *)theMapView
                    andLatitude:(float)latitude
                   andLongitude:(float)longitude
                       andTitle:(NSString *)title
                   withSubtitle:(NSString *)subtitle;


@end

