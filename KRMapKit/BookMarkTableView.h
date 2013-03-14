//
//  BookMarkTableView.h
//  KRMapKit
//
//  Created by Lai Wen Yu on 13/3/2.
//  Copyright (c) 2013年 Wayne Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationList.h"

@interface BookMarkTableView : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>{
    InformationList *infoListClass;
    UIAlertView *editAlertView;
    UITextField *editTextField;
    int bookMarkPath;
}

@property (nonatomic, retain) InformationList *infoListClass;
@property (nonatomic, retain) UIAlertView *editAlertView;
@property (nonatomic, retain) UITextField *editTextField;

@end
