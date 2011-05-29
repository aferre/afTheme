//
//  afThemesDemoAppDelegate.h
//  afThemesDemo
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afThemeBrowser.h"

@class afThemeBrowser;

@interface afThemesDemoAppDelegate : NSObject <UIApplicationDelegate> {
    afThemeBrowser *themeBrowser;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet afThemeBrowser *themeBrowser;

@end
