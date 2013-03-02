//
//  HistoryTableView.h
//  KRMapKit
//
//  Created by Lai Wen Yu on 13/2/25.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationList.h"
#import "DetailTableView.h"

@interface HistoryTableView : UITableViewController{
    InformationList *infoListClass;
    int totalNumber;
    NSUserDefaults *defaultUser;
}

@property (nonatomic, retain) InformationList *infoListClass;
@property (nonatomic, retain) NSUserDefaults *defaultUser;

@end
