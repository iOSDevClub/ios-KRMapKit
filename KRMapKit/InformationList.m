//
//  InformationList.m
//  KRMapKit
//
//  Created by apple on 13/2/22.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
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

#pragma InfoListDatas  ================================================================

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

//刪除infoListData資料
-(void) deleteInfoListDataPath:(int) path
{
    [self fetchInfoListDataAllInformation];
    
    infoListData = [results objectAtIndex:path];
    
    NSError *error;
    
    NSSet *infoListSet = infoListData.coordinate;
    NSArray *infoListArray = [infoListSet allObjects];
    
    for (int i=0;i<[results count];i++){
        infoListData = [results objectAtIndex:i];
        
        if (path == [infoListData.index intValue]){
            //必需先刪除當天裡的所有資料
            for (int i=0;i<[infoListArray count];i++){
                
                coordinate = [infoListArray objectAtIndex:i];
                
                [context deleteObject:coordinate];
            }
            
            //NSLog(@"被刪除的index:%d", [infoListData.index intValue]);
            
            //刪完之後才可以刪掉當天的資料
            [context deleteObject:infoListData];
            
            if (![context save:&error]){
                NSLog(@"Error, Delete listData fail");
            }else{
                //NSLog(@"Result:%@",results);
            }
            [self fetchInfoListDataAllInformation];
        }
    }
    
    //因為受刪除日期的影響, 大於被刪除的infoListData.index必須重新給予新的index
    for (int i=0;i<[results count];i++){
        infoListData = [results objectAtIndex:i];
        
        if ([infoListData.index intValue] > path){
            
            infoListData.index = [NSNumber numberWithInt:[infoListData.index intValue]-1];
            //NSLog(@"重新命名的index:%d", [infoListData.index intValue]);
            
            if (![context save:&error]){
                NSLog(@"Error, Rename infoList.index fail");
            }else{
                //NSLog(@"Reults:%@", results);
            }
        }
    }
    [self fetchInfoListDataAllInformation];
}

//刪除infoListCoordinate資料
-(void) deleteInfoCoordinatePath:(int) path
{
    [self fetchInfoListDataAllInformation];
    
    NSSet *infoListSet = infoListData.coordinate;
    NSArray *infoListArray = [infoListSet allObjects];
    
    //取得被刪除的coordinate number
    for (int i =0;i<[infoListArray count];i++){
        coordinate = [infoListArray objectAtIndex:i];
        
        if (path == [coordinate.number intValue]){
            
            //NSLog(@"被刪除的coordinate.number:%d",[coordinate.number intValue]);
            
            [context deleteObject:coordinate];
        }
    }
    
    NSError *error;
    
    //刪除後, 再重新命名比被刪除number大的number
    for (int i=0;i<[infoListArray count];i++){
        coordinate = [infoListArray objectAtIndex:i];
        
        if ([coordinate.number intValue] > path){
            coordinate.number = [NSNumber numberWithInt:[coordinate.number intValue]-1];
            //NSLog(@"重新命名的coordinat.number:%d",[coordinate.number intValue]);
        }
        
        if (![context save:&error]){
            NSLog(@"Error, Rename coordinate.number fail");
        }else{
            //NSLog(@"Coordinate:%@",coordinate);
        }
    }
    
    [self fetchInfoListDataAllInformation];
}

#pragma BookMark ================================================================

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
        //NSLog(@"bookMark:%@",bookMark);
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
        NSLog(@"Error, Delete bookMark fail");
    }else{
        //NSLog(@"bookMarkResult:%@", bookMarkResults);
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
        //NSLog(@"bookMark:%@",bookMark);
    }
    
    [self fetchBookMarkAllInformation];
}


@end
