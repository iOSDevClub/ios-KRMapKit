//
//  KRAnnotationProtocol.h
//  KRMapKit
//
//  ilovekalvar@gmail.com
//
//  Created by Kuo-Ming Lin on 2013/03/11.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KRAnnotationProtocol : NSObject <MKAnnotation>
{
    //原生的設定
    CLLocationCoordinate2D coordinate;
    //如果要客製化 leftCallout 的話，這裡不能有文字的設定
    NSString *title;
    NSString *subtitle;
    //改設定這裡
    NSString *customTitle;
    NSString *customSubtitle;
    //
    NSString *idIndex;
    UIImage *leftImage;
}

//宣告 coordinate
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
//
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic, strong) NSString *customSubtitle;
@property (nonatomic, strong) NSString *idIndex;
@property (nonatomic, strong) UIImage *leftImage;

-(id)initWithCoordinate:(CLLocationCoordinate2D)_theCoordinate customTitle:(NSString *)_theTitle customSubtitle:(NSString *)_theSubtitle;


@end

