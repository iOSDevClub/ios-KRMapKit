//
//  AppDelegate.h
//  KRMapKit
//
//  ilovekalvar@gmail.com
//  wing50kimo@gmail.com
//
//  Created by Kuo-Ming Lin & Wayne Lai on 2013/01/01.
//  Copyright (c) 2013年 Kuo-Ming Lin & Wayne Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/types.h>
#import <sys/sysctl.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
