//
//  afThemeManager.m
//  g2park
//
//  Created by adrien ferré on 28/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//
/*
 var ThemesList = [
 {'name':'DummyTheme'},
 {'name':'G2Theme'}
 ];
 
 var DummyTheme = {'name':'DummyTheme',
 'images':[
 {'name':'Pin Station Free',
 'location':'/Map/Pin-PP-Free',
 'url': root + 'DummyTheme/images/pin-station-free.png'},
 {'name':'Pin Station Occupied',
 'location':'/Map/Pin-PP-Occ',
 'url': root + 'DummyTheme/images/pin-station-occupied.png'}
 ],
 'strings':[
 {'name':'str1',
 'location':'/Map/Pin-PP-Free-subtitle',
 'content':'Pin-PP-Free-subtitle'},
 {'name':'str2',
 'location':'/Map/Pin-PP-Occ-subtitle',
 'content':'Pin-PP-Occupied-subtitle'}
 ]
 };
 
 var G2Theme = {'name':'G2Theme',
 'images':[
 {'name':'Pin Station Free',
 'location':'/Map/Pin-PP-Free',
 'url':root + 'G2Theme/images/pin-station-free.png'},
 {'name':'Pin Station Occupied',
 'location':'/Map/Pin-PP-Occ',
 'url':root + 'G2Theme/images/pin-station-occupied.png'}
 ],
 'strings':[
 {'name':'str1',
 'location':'/Map/Pin-PP-Free-subtitle',
 'content':'Pin-PP-Free-subtitle'},
 {'name':'str2',
 'location':'/Map/Pin-PP-Occ-subtitle',
 'content':'Pin-PP-Occupied-subtitle'}
 ]
 };
 
 var img = {'name':'img1',
 'location':'/Map/Pin-PP-Free',
 'url':'http://localhost/img1.png'};
 
 var str = {'name':'str1',
 'location':'/Map/Pin-PP-Free-Subtitle',
 'content':'Pouetounet!'};	
 */

#import "afThemeManager.h"
#import "afStringExt.h"
#import "NSFileManagerExtensions.h"
#define THEME_SERVER_URL @"http://localhost:8000/"
#define DETAIL_THEME_SERVER_URL_EXT @"Themes"

@implementation afThemeManager

SYNTHESIZE_SINGLETON_FOR_CLASS(afThemeManager)

@synthesize themesList;

#pragma mark --
#pragma mark -- Init and load
#pragma mark --

- (id) init{
	self = [super init];
    
	if (self){
        /*  if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathToThemesList] isDirectory:NO]){
         NSArray *a = [NSArray arrayWithContentsOfFile:[self pathToThemesList]];
         
         if ([a count]!= 0)
         themesList = [[NSMutableArray alloc] initWithContentsOfFile:[self pathToThemesList]];
         else{    themesList = [[NSMutableArray alloc] init];
         [self loadThemesList];
         }
         }
         else {
         themesList = [[NSMutableArray alloc] init];
         [self loadThemesList];
         }*/
        themesList = [[NSMutableDictionary alloc] init];
        [self loadThemesList];
        
	}
	return self;
}

-(void) load{
    
    NSLog(@"CurrentTheme is %@",[self currentTheme]);    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathToThemesList]]){
        NSLog(@"Has a themes list %@",[NSArray arrayWithContentsOfFile:[self pathToThemesList]]);   
    } 
    
}

#pragma mark --
#pragma mark -- getters, setters
#pragma mark --

-(UIImage *) imageAtLocation:(NSString *)loc{

    return [self imageForTheme:[self currentTheme] atLocation:loc];
}
- (UIImage *) imageForTheme:(NSString *)themeName atLocation:(NSString *)location{
    NSString *path = [NSFileManager documentDirectory];
    path = [path stringByAppendingPathComponent:@"Themes"];
    path = [path stringByAppendingPathComponent:themeName];
    path = [path stringByAppendingFormat:@"%@",location];
    
    return [UIImage imageWithContentsOfFile:path];
}

- (NSArray *) imagesForTheme:(NSString *)themeName{
    return [[self dicoForTheme:themeName] objectForKey:@"images"];
}

- (NSArray *) stringsForTheme:(NSString *)themeName{
    return [[self dicoForTheme:themeName] objectForKey:@"strings"];
}

- (NSString *) rootUrlString{
    return THEME_SERVER_URL;
}

- (NSURL *) rootUrl{
    return [NSURL URLWithString: THEME_SERVER_URL];
}

-(NSMutableDictionary *) dicoForTheme:(NSString *)the{
    
    return [self.themesList objectForKey:the];
}

- (void) setCurrentTheme:(NSString *)newTheme{
    [[NSUserDefaults standardUserDefaults] setObject:newTheme forKey:@"currentTheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) currentTheme{
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *currentTheme =  [[NSUserDefaults standardUserDefaults] objectForKey:@"currentTheme"];
    
    if (currentTheme){
        return currentTheme; 
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Default" forKey:@"currentTheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return @"Default";
}


-(void) saveThemeList:(NSArray *)list{
    
}

#pragma mark --
#pragma mark -- Themes loading
#pragma mark --

-(void) loadTheme:(NSString *)th{
    
    NSURL *url = [NSURL URLWithString:THEME_SERVER_URL];
    url = [url URLByAppendingPathComponent:DETAIL_THEME_SERVER_URL_EXT];
    url = [url URLByAppendingPathComponent:th];
    
    ASIHTTPRequest *req= [ASIHTTPRequest requestWithURL:url];
    req.delegate = self;
    
    NSDictionary *dico = [NSDictionary dictionaryWithObject:[NSString stringWithFormat: @"LoadTheme:%@",th] forKey:@"type"];
    [req setUserInfo:dico];
    
    [req startAsynchronous];
    NSLog(@"Starting loading theme %@ with url %@",th,req.url);
}

-(void) loadThemesList{
    
    NSURL *url = [NSURL URLWithString:THEME_SERVER_URL];
    url = [url URLByAppendingPathComponent:@"Themes"];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    req.delegate = self;
    NSDictionary *dico = [NSDictionary dictionaryWithObject:@"LoadThemesList" forKey:@"type"];
    [req setUserInfo:dico];
    
    [req startAsynchronous];
    
    NSLog(@"Starting loading theme list %@",[req url]);
}

-(void) loadThemeFiles:(NSString *)themeName{
    
    NSArray *images = [self imagesForTheme:themeName];
    NSArray *strings = [self stringsForTheme:themeName];
    
    for (NSDictionary *imgDico in images){
        NSString *location = [imgDico objectForKey:@"location"];
        NSURL *url = [NSURL URLWithString:[imgDico objectForKey:@"url"]];
        NSLog(@"URL %@",url);
        ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
        req.delegate = self;
        NSMutableDictionary *dico = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat: @"LoadThemeImage:%@,%@",themeName,location] forKey:@"type"];
        [req setUserInfo:dico];
        [req startAsynchronous];
    }
}

#pragma mark --
#pragma mark -- Paths
#pragma mark --

-(NSString *) pathToTheme:(NSString *)themeName atLocation:(NSString *)loc{
    NSString *path = [self pathToTheme:themeName];
    path = [path stringByAppendingFormat:@"%@",loc];
    NSString *fn = [path lastPathComponent];
    NSString *dir = [path stringByDeletingLastPathComponent];
    NSError *er;
    NSLog(@"CREATING DIR: %@",dir);
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&er]){
        NSLog(@"ERROR CREATING DIR: %@, %@, %@",dir,[er localizedDescription], [er localizedFailureReason]);
    }
    NSLog(@"Path returned is %@, filename is %@",path,fn);
    return path;
}

-(NSString *) pathToTheme:(NSString *)themeName{
    NSString *path = [self rootPath];
    path = [path stringByAppendingPathComponent:themeName];
    NSError *er;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&er]){
        NSLog(@"ERROR CREATING DIR: %@, %@, %@",path,[er localizedDescription], [er localizedFailureReason]);
    }
    return path;
}
-(NSString *) rootPath{
    NSString *doc = [NSFileManager documentDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"Themes"];
    NSError *er;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&er]){
        NSLog(@"ERROR CREATING DIR: %@, %@, %@",path,[er localizedDescription], [er localizedFailureReason]);
    }
    return path;
}
-(NSString *) pathToThemesList{
    NSString *path = [self rootPath];
    NSError *er;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&er]){
        NSLog(@"ERROR CREATING DIR: %@, %@, %@",path,[er localizedDescription], [er localizedFailureReason]);
    }
    path = [path stringByAppendingFormat:@"/themesList"];
    return path;
}

#pragma mark --
#pragma mark -- ASIHTTPREQUEST Delegate
#pragma mark -- 

- (void) request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    
    NSDictionary *userInfo = [request userInfo];
    
    NSString *reqType = [userInfo valueForKey:@"type"];
    
    if ([reqType rangeOfString:@"LoadTheme:"].length != 0){
        NSString *themeName = [reqType stringByReplacingOccurrencesOfString:@"LoadTheme:" withString:@""];
        NSLog(@"Has loaded theme %@",themeName);
        
        NSMutableDictionary *dico = [[NSMutableDictionary alloc] initWithDictionary:[self dicoForTheme:themeName]];
        
        //The string received from google's servers
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString %@",jsonString);
        
        //JSON Framework magic to obtain a dictionary from the jsonString.
        NSDictionary *results = [jsonString JSONValue];
        
        NSArray *imgs = [results objectForKey:@"images"];
        NSLog(@"imgs array %@",imgs);
        
        NSArray *strs = [results objectForKey:@"strings"];
        NSLog(@"strs array %@",strs );
        
        [dico setObject:imgs forKey:@"images"];
        [dico setObject:strs forKey:@"strings"];
        
        [themesList setObject:dico forKey:themeName];
        [self loadThemeFiles:themeName];
        [themesList writeToFile:[self pathToThemesList] atomically:YES];
    }
    else if ([reqType isEqualToString:@"LoadThemesList"]) {
        NSLog(@"Loading themes list");
        
        //The string received from google's servers
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //JSON Framework magic to obtain a dictionary from the jsonString.
        NSArray *results = [jsonString JSONValue];
        
        NSLog(@"array %@",results);
        
        for (NSDictionary *dico in results){
            NSMutableDictionary *di = [[NSMutableDictionary alloc] initWithDictionary:dico];
            NSString *name =[di objectForKey:@"name"];
            [themesList setObject:[[NSMutableDictionary alloc] init] forKey:name];
            [self loadTheme:name];
            [di release];
        }
        [themesList writeToFile:[self pathToThemesList] atomically:YES];
    } else if ([reqType rangeOfString:@"LoadThemeImage:"].length != 0){
        NSString *str = [reqType stringByReplacingOccurrencesOfString:@"LoadThemeImage:" withString:@""];
        NSArray * ar = [str componentsSeparatedByString:@","];
        NSString *themeName = [ar objectAtIndex:0];
        NSString *loc = [ar objectAtIndex:1];
        NSLog(@"Loading theme image %@ at %@",themeName, loc);
        NSError *er;
        if (![data writeToFile:[self pathToTheme:themeName atLocation:loc] options:NSDataWritingAtomic error:&er]){
            NSLog(@"Write returned error: %@", [er localizedDescription]);
        }
    }
}

- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader{
    
}

- (void) request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    
}
- (void) requestFailed:(ASIHTTPRequest *)request{
    
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    
    NSDictionary *userInfo = [request userInfo];
    
    NSString *reqType = [userInfo valueForKey:@"type"];
    
    
}
- (void) requestRedirected:(ASIHTTPRequest *)request{
    
}
- (void) requestStarted:(ASIHTTPRequest *)request{
    
    NSDictionary *userInfo = [request userInfo];
    
    NSString *reqType = [userInfo valueForKey:@"type"];
    NSLog(@"Started request %@",reqType);
}

@end
