//
//  afThemedImage.m
//  g2park
//
//  Created by adrien ferré on 28/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afThemedImage.h"
#import "afThemeManager.h"
#import "NSFileManagerExtensions.h"

@implementation afThemedImage

@synthesize location,theme;

-(id) initWithTheme:(NSString *)th 
        andLocation:(NSString *)loc{
    
    NSString *path = [NSFileManager documentDirectory];
    path = [path stringByAppendingPathComponent:th];
    path = [path stringByAppendingFormat:@"%@",loc];
    
    NSLog(@"loading image from file %@",path);
    self = [super initWithData:[NSData dataWithContentsOfFile:path]];
    if (self){
        self.theme = th;
        self.location = loc;
    }
    
    return self;
}



@end
