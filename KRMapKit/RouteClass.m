//
//  RouteClass.m
//  KRMapKit
//
//  Created by apple on 13/2/26.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "RouteClass.h"

@implementation RouteClass

@synthesize address;
@synthesize hour;
@synthesize latitude;
@synthesize longitude;
@synthesize minute;
@synthesize number;
@synthesize second;
@synthesize count;
@synthesize array;


-(void) encodeWithCoder:(NSCoder *) encoder
{
    //Encode properties, other class variables
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.hour forKey:@"hour"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.minute forKey:@"minute"];
    [encoder encodeObject:self.number forKey:@"number"];
    [encoder encodeObject:self.second forKey:@"second"];
    [encoder encodeObject:self.count forKey:@"count"];
}

-(id) initWithCoder:(NSCoder *) decoder
{
    self = [super init];
    
    if (self != nil){
        self.address = [decoder decodeObjectForKey:@"address"];
        self.hour = [decoder decodeObjectForKey:@"hour"];
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.minute = [decoder decodeObjectForKey:@"minute"];
        self.number = [decoder decodeObjectForKey:@"number"];
        self.second = [decoder decodeObjectForKey:@"second"];
        self.count = [decoder decodeObjectForKey:@"count"];
    }
    return self;
}

@end
