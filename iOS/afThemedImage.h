//
//  afThemedImage.h
//  g2park
//
//  Created by adrien ferré on 28/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface afThemedImage : UIImage {
    
    NSString *theme;
    NSString *location;
}

@property (nonatomic,retain) NSString *theme;
@property (nonatomic,retain) NSString *location;

-(id) initWithTheme:(NSString *)th 
        andLocation:(NSString *)loc;
@end
