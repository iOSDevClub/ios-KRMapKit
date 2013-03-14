//
//  InfoListData.h
//  KRMapKit
//
//  Created by apple on 13/2/23.


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coordinate;

@interface InfoListData : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *coordinate;
@end

@interface InfoListData (CoreDataGeneratedAccessors)

- (void)addCoordinateObject:(Coordinate *)value;
- (void)removeCoordinateObject:(Coordinate *)value;
- (void)addCoordinate:(NSSet *)values;
- (void)removeCoordinate:(NSSet *)values;

@end
