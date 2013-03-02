//
//  InformationList.h
//  KRMapKit
//
//  Created by apple on 13/2/22.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "InfoListData.h"
#import "Coordinate.h"
#import "BookMark.h"

@interface InformationList : UIView{
    int dateIndex;
    NSMutableArray *results;
    NSMutableArray *bookMarkResults;
    //Core data
    InfoListData *infoListData;
    Coordinate *coordinate;
    BookMark *bookMark;
    NSManagedObjectContext *context;
    NSUserDefaults *defaultUser;
    NSArray *infoListObject;
}

@property (nonatomic, assign) int dateIndex;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) NSMutableArray *bookMarkResults;
@property (nonatomic, retain) InfoListData *infoListData;
@property (nonatomic, retain) Coordinate *coordinate;
@property (nonatomic, retain) BookMark *bookMark;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSUserDefaults *defaultUser;
@property (nonatomic, retain) NSArray *infoListObject;

//比對取出InfoListData
-(void) fetchInfoListDataAllInformation;
//儲存當天的日期
-(void) saveIndex:(int) index andYear:(int) year andMonth:(int) month andDay:(int) day;
//儲存座標資訊, 時、分、秒、地址、序數、次數、緯度、經度
-(void) saveInformationDataHour:(int) hour Min:(int) min Sec:(int) second Addr:(NSString *) addr Count:(int) count Num:(int) num
                       Latitude:(float) lat Longitude:(float) lon;
//取出infoListObject
-(void) getAllCoordinate;
//刪除infoListData資料
-(void) deleteInfoListDataPath:(int) path;
//刪除infoListCoordinate資料
-(void) deleteInfoCoordinatePath:(int) path;

//儲存BookMark
-(void) saveName:(NSString *) name Address:(NSString *) address Latitude:(float) lat Longitude:(float) lon;
//比對取出BookMark
-(void) fetchBookMarkAllInformation;
//刪除BookMark的資料
-(void) deleteBookMarkDataPath:(int) path;
//修改BookMark的資料(名稱)
-(void) modifyBookMarkName:(NSString *) name Path:(int) path;

@end
