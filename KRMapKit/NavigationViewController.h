//
//  NavigationViewController.h
//  KRMapKit
//
//  wing50kimo@gmail.com
//
//  Created by Wayne Lai on 2013/01/01.
//  Copyright (c) 2013年 Wayne Lai. All rights reserved.
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
