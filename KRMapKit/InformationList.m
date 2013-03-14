//
//  InformationList.m
//  KRMapKit
//
//  wing50kimo@gmail.com
//
//  Created by Wayne Lai on 2013/01/01.
//  Copyright (c) 2013年 Wayne Lai. All rights reserved.
//

#import "InformationList.h"

@implementation InformationList

@synthesize dateIndex;
@synthesize results, bookMarkResults;
@synthesize infoListData, coordinate, bookMark;
@synthesize context;
@synthesize defaultUser;
@synthesize infoListObject;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        context = [appDelegate managedObjectContext];
        
        results = [[NSMutableArray alloc] init];
        bookMarkResults = [[NSMutableArray alloc] init];
        
        defaultUser = [NSUserDefaults standardUserDefaults];
        
        infoListObject = [[NSArray alloc] init];
        
        [self fetchInfoListDataAllInformation];
        [self fetchBookMarkAllInformation];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma InfoListDatas 

//儲存當天的日期
-(void) saveIndex:(int) index andYear:(int) year andMonth:(int) month andDay:(int) day
{
    [self fetchInfoListDataAllInformation];
    
    infoListData = [NSEntityDescription insertNewObjectForEntityForName:@"InfoListData" inManagedObjectContext:context];
    
    infoListData.index = [NSNumber numberWithInt:index];
    infoListData.year = [NSNumber numberWithInt:year];
    infoListData.month = [NSNumber numberWithInt:month];
    infoListData.day = [NSNumber numberWithInt:day];
    
    NSError *error;
    
    if (![context save:&error]){
        NSLog(@"Error, Save index fail");
    }else{
        //NSLog(@"infoListData:%@",infoListData);
    }
    
    [self fetchInfoListDataAllInformation];
}

//比對取出InfoListData
-(void) fetchInfoListDataAllInformation
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InfoListData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *indexSort = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *indexArray = [NSArray arrayWithObject:indexSort];
    [fetchRequest setSortDescriptors:indexArray];
    
    NSError *error;
    results = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    //NSLog(@"result count:%d", [results count]);
}

//儲存座標資訊, 時、分、秒、地址、序數、次數、緯度、經度
-(void) saveInformationDataHour:(int) hour Min:(int) min Sec:(int) second Addr:(NSString *) addr Count:(int) count Num:(int) num
                       Latitude:(float) lat Longitude:(float) lon
{
    [self fetchInfoListDataAllInformation];
    
    //NSLog(@"save index:%d",[[defaultUser objectForKey:@"index"] intValue]);
    
    infoListData = [results objectAtIndex:[[defaultUser objectForKey:@"index"] intValue]];
    
    NSSet *infoListSet = infoListData.coordinate;
    
    infoListObject = [infoListSet allObjects];
    
    coordinate = (Coordinate *)[NSEntityDescription insertNewObjectForEntityForName:@"Coordinate" inManagedObjectContext:context];
    
    coordinate.hour = [NSNumber numberWithInt:hour];
    coordinate.minute = [NSNumber numberWithInt:min];
    coordinate.second = [NSNumber numberWithInt:second];
    coordinate.address = [NSString stringWithString:addr];
    coordinate.count = [NSNumber numberWithInt:count];
    coordinate.number = [NSNumber numberWithInt:num];
    coordinate.latitude = [NSNumber numberWithFloat:lat];
    coordinate.longitude = [NSNumber numberWithFloat:lon];
    coordinate.infoListData = self.infoListData;
    
    NSError *error;
    
    if (![context save:&error]){
        NSLog(@"Error, Save coordinate fail");
    }else{
        //NSLog(@"coordinate:%@",coordinate);
    }
}

//取出infoListObject
-(void) getAllCoordinate
{
    //NSLog(@"get Index:%d", [[defaultUser objectForKey:@"index"] intValue]);
    
    infoListData = [results objectAtIndex:[[defaultUser objectForKey:@"index"] intValue]];
    
    NSSet *infoListSet = infoListData.coordinate;
    
    infoListObject = [infoListSet allObjects];
}

#pragma BookMark 

//儲存bookMark
-(void) saveName:(NSString *) name Address:(NSString *) address Latitude:(float) lat Longitude:(float) lon
{
    [self fetchBookMarkAllInformation];
    
    bookMark = [NSEntityDescription insertNewObjectForEntityForName:@"BookMark" inManagedObjectContext:context];
    
    bookMark.name = [NSString stringWithString:name];
    bookMark.address = [NSString stringWithString:address];
    bookMark.latitude = [NSNumber numberWithFloat:lat];
    bookMark.longitude = [NSNumber numberWithFloat:lon];
    
    NSError *error;
    
    if (![context save:&error]){
        NSLog(@"Error, Save index fail");
    }else{
        NSLog(@"bookMark:%@",bookMark);
    }
    
    [self fetchBookMarkAllInformation];
}

//比對取出BookMark
-(void) fetchBookMarkAllInformation
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookMark" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *addressSort = [[NSSortDescriptor alloc] initWithKey:@"address" ascending:YES];
    NSArray *addressArray = [NSArray arrayWithObject:addressSort];
    [fetchRequest setSortDescriptors:addressArray];
    
    NSError *error;
    bookMarkResults = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    //NSLog(@"bookMarkResults:%@",bookMarkResults);
}

//刪除BookMark的資料
-(void) deleteBookMarkDataPath:(int) path
{
    [self fetchBookMarkAllInformation];
    
    bookMark = [bookMarkResults objectAtIndex:path];
    
    NSError *error;
    
    [context deleteObject:bookMark];
    
    if (![context save:&error]){
        NSLog(@"delete error");
    }else{
        NSLog(@"bookMarkResult:%@", bookMarkResults);
    }
    
    [self fetchBookMarkAllInformation];
}

//修改BookMark的資料(名稱)
-(void) modifyBookMarkName:(NSString *) name Path:(int) path
{
    [self fetchBookMarkAllInformation];
    
    bookMark = [bookMarkResults objectAtIndex:path];
    
    bookMark.name = [NSString stringWithString:name];
    
    NSError *error;
    
    if (![context save:&error]){
        NSLog(@"Error, Save index fail");
    }else{
        NSLog(@"bookMark:%@",bookMark);
    }
    
    [self fetchBookMarkAllInformation];
}


@end
