//
//  NavigationViewController.h
//  KRMapKit
//
//  Created by Lai Wen Yu on 13/3/1.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NavigationViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate,
                                                        UIPickerViewDataSource , CLLocationManagerDelegate>
{
    BOOL isSelect;
    float nowLatitude, nowLongitude;
    NSMutableArray *startPoint, *endPoint;
    NSMutableArray *bookMarkResults;
}

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) float nowLatitude, nowLongitude;
@property (nonatomic, retain) NSMutableArray *startPoint, *endPoint;
@property (nonatomic, retain) NSMutableArray *bookMarkResults;
@property (nonatomic, retain) IBOutlet UIPickerView *sourcePicker;
@property (nonatomic, retain) IBOutlet UITextField *startPlace, *endPlace;
@property (nonatomic, retain) IBOutlet UIButton *nowButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableArray *) array;

-(IBAction) getNowCoordinate:(id) sender;

-(IBAction) backToViewController:(id) sender;

@end
