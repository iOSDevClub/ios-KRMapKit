//
//  DetailTableView.h
//  KRMapKit
//
//  Created by apple on 13/2/25.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationList.h"

@interface DetailTableView : UITableViewController{
    InformationList *infoListClass;
    int selectIndex, coordinateNumber;
    NSMutableArray *oldDataArray, *allDataArray, *totalCountArray;
    NSUserDefaults *defaultUser;
}

@property (nonatomic, retain) InformationList *infoListClass;
@property (nonatomic, assign) int selectIndex, coordinateNumber;
@property (nonatomic, retain) NSMutableArray *oldDataArray, *allDataArray, *totalCountArray;
@property (nonatomic, retain) NSUserDefaults *defaultUser;

@end
