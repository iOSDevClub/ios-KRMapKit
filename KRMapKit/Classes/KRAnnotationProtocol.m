//
//  KRAnnotationProtocol.m
//  KRMapKit
//
//  ilovekalvar@gmail.com
//
//  Created by Kuo-Ming Lin on 2013/03/11.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "KRAnnotationProtocol.h"

@implementation KRAnnotationProtocol

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
//
@synthesize customTitle, customSubtitle;
@synthesize idIndex;
@synthesize leftImage;


-(id)initWithCoordinate:(CLLocationCoordinate2D)_theCoordinate
            customTitle:(NSString *)_theTitle
         customSubtitle:(NSString *)_theSubtitle
{
    self = [super init];
    if( self )
    {
        self.title          = @" ";
        self.subtitle       = @" ";
        self.customTitle    = _theTitle;
        self.customSubtitle = _theSubtitle;
        self.coordinate     = _theCoordinate;
        self.idIndex        = nil;
        self.leftImage      = nil;
    }
    return self;
}

-(void)delloc
{    
    self.title    = nil;
    self.subtitle = nil;
    //
    self.customTitle    = nil;
    self.customSubtitle = nil;
    self.idIndex        = nil;
    self.leftImage      = nil;
}



@end
