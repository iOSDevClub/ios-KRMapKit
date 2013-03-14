//
//  KRAnnotationView.m
//
//
//  Created by Kalvar on 13/3/6.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

/*
 * @ MKAnnotationView 本身就只是大頭針
 *   - 這裡沒有包含「按下大頭針」後所出現的「註釋」說明畫面 ( Callout )。
 */

#import <MapKit/MapKit.h>

@class KRAnnotationProtocol;

@interface KRAnnotationView : MKAnnotationView
{
    UIImageView *leftImageView;
    UIView *customContentView;
    
}

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIView *customContentView;

-(id)initWithAnnotation:(KRAnnotationProtocol *)_krAnnotation reuseIdentifier:(NSString *)_reuseIdentifier;
-(void)makeCustomContent;

@end
