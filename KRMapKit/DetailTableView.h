//
//  DetailTableView.h
//  KRMapKit
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
