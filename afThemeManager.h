//
//  afThemeManager.h
//  g2park
//
//  Created by adrien ferré on 28/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "gdzSingleton.h"

@interface afThemeManager : NSObject <ASIHTTPRequestDelegate>{
    
    NSMutableDictionary *themesList;
}

DECLARE_SINGLETON_FOR_CLASS(afThemeManager)

@property (nonatomic,retain) NSMutableDictionary *themesList;

- (NSString *) currentTheme;

- (NSString *) rootUrlString;

- (void) load;

- (void) loadThemesList;

- (NSString *) pathToThemesList;

- (NSArray *)imagesForTheme:(NSString *)themeName;

- (NSArray *) stringsForTheme:(NSString *)themeName;

- (NSDictionary *) dicoForTheme:(NSString *)th;

@end
