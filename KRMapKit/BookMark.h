//
//  BookMark.h
//  KRMapKit
//
//  Created by apple on 13/2/27.


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookMark : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;

@end
