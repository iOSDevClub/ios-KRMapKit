//
//  SelfMKAnnotationProtocol.m
//  KRMapKit
//
//  ilovekalvar@gmail.com
//
//  Created by Kuo-Ming Lin on 12/11/25.
//  Copyright (c) 2012年 Kuo-Ming Lin. All rights reserved.
//
#import "KRAnnotationProtocol.h"

@implementation KRAnnotationProtocol

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

/*
 -(id) initWithCoordinate:(CLLocationCoordinate2D)theCoordinate title:(NSString *)theTitle subtitle:(NSString *)theSubtitle{
 self = [super init];
 [self setCoordinate:theCoordinate];
 self.title    = theTitle;
 self.subtitle = theSubtitle;
 return self;
 }
 */

/*
 -(id) initWithCoordinate:(CLLocationCoordinate2D) theCoordinate{
 if( self == [super init] ){
 coordinate = theCoordinate;
 }
 return self;
 }
 */


-(void) delloc{
    self.title    = nil;
    self.subtitle = nil;
}


/*
 -(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate{
 coordinate = newCoordinate;
 }
 */


@end
