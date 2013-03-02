//
//  RouteClass.h
//  KRMapKit
//
//  Created by apple on 13/2/26.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteClass : NSObject{
    NSString *address;
    NSNumber *hour;
    NSNumber *latitude;
    NSNumber *longitude;
    NSNumber *minute;
    NSNumber *number;
    NSNumber *second;
    NSNumber *count;
    
    NSMutableArray *array;
}

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSNumber *hour;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *minute;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSNumber *second;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSMutableArray *array;

@end
