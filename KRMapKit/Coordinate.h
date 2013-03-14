//
//  Coordinate.h
//  KRMapKit
//
//  Created by apple on 13/2/23.


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InfoListData;

@interface Coordinate : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * minute;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * second;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) InfoListData *infoListData;

@end
