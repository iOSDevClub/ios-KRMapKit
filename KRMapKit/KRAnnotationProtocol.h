//
//  SelfMKAnnotationProtocol.h
//  KRMapKit
//
//  ilovekalvar@gmail.com
//
//  Created by Kuo-Ming Lin on 12/11/25.
//  Copyright (c) 2012年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//自訂義 MKAnnotatioin Protocol 協定
@interface KRAnnotationProtocol : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

//-(id) initWithCoordinate: (CLLocationCoordinate2D) theCoordinate title:(NSString *)theTitle subtitle:(NSString *)theSubtitle;

//宣告 coordinate
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

//-(id) initWithCoordinate:(CLLocationCoordinate2D) theCoordinate;

@end

