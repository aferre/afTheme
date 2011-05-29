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

-(NSString *) pathToTheme:(NSString *)themeName;

-(NSString *) rootPath;

- (NSString *) currentTheme;

- (void) setCurrentTheme:(NSString *)newTheme;

- (NSString *) rootUrlString;

- (void) load;

- (void) loadThemesList;

- (NSString *) pathToThemesList;

- (UIImage *) imageAtLocation:(NSString *)loc;

- (NSArray *)imagesForTheme:(NSString *)themeName;

- (NSArray *) stringsForTheme:(NSString *)themeName;

- (NSMutableDictionary *) dicoForTheme:(NSString *)th;

- (UIImage *) imageForTheme:(NSString *)themeName atLocation:(NSString *)location;

@end
