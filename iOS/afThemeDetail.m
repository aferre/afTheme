//
//  afThemeDetail.m
//  g2park
//
//  Created by adrien ferré on 25/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afThemeDetail.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "afThemedImage.h"
#import "afASIQueue.h"
#import "afThemeManager.h"
#import "NSFileManagerExtensions.h"

#define DETAIL_THEME_SERVER_URL @"http://localhost:8000/Themes/"

@implementation afThemeDetail

@synthesize currentTheme;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTheme:(NSString *) th
{
    self = [super initWithNibName:@"afThemeDetail" bundle:nil];
    
    if (self) {
        self.title = th;
        currentTheme = [NSString stringWithString:th];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Use this theme" style:UIBarButtonItemStyleBordered target:self action:@selector(useThisTheme)];
        
        self.navigationItem.rightBarButtonItem = item;
    }
    return self;
}

-(void) useThisTheme{
    
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [[[afThemeManager sharedafThemeManager] imagesForTheme:currentTheme] count];
        case 1: 
            return [[[afThemeManager sharedafThemeManager] stringsForTheme:currentTheme] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
        NSArray *imgArray = [[afThemeManager sharedafThemeManager] imagesForTheme:currentTheme];
        NSDictionary *imgDico = [imgArray objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"imgCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            // afThemedImage *i = [[afThemedImage alloc] initWithTheme:currentTheme andLocation:[imgDico objectForKey:@"location"]];
            NSString *path = [NSFileManager documentDirectory];
            path = [path stringByAppendingPathComponent:@"Themes"];
            path = [path stringByAppendingPathComponent:currentTheme];
            path = [path stringByAppendingFormat:@"%@",[imgDico objectForKey:@"location"]];
            
            UIImage *i = [UIImage imageWithContentsOfFile:path];
            //UIImage *i = [UIImage imageNamed:path];
            //UIImage *i = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
            UIImageView *img = [[UIImageView alloc] initWithImage:i];
            
            NSLog(@"PATH IS %@",path);
            img.frame = CGRectMake(0, 0, 50,50);
            img.tag = 1;
            [cell addSubview:img];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width + 5, 0, 200, 20)];
            [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [titleLabel setTextColor:[UIColor blackColor]];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            titleLabel.tag = 2;
            [cell addSubview:titleLabel]; 
        }
        NSString *path = [NSFileManager documentDirectory];
        path = [path stringByAppendingPathComponent:@"Themes"];
        path = [path stringByAppendingPathComponent:currentTheme];
        path = [path stringByAppendingFormat:@"%@",[imgDico objectForKey:@"location"]];
        
        UIImage *i = [UIImage imageWithContentsOfFile:path];
        //UIImage *i = [UIImage imageNamed:path];
        //UIImage *i = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        UIImageView *imgView = (UIImageView *) [cell viewWithTag:1];
        imgView.image = i;
        
     /*   UIImageView *imgView = (UIImageView *) [cell viewWithTag:1];
        //afThemedImage *i = [[afThemedImage alloc] initWithTheme:currentTheme andLocation:[imgDico objectForKey:@"location"]];
        NSString *path = [NSFileManager documentDirectory];
        path = [path stringByAppendingPathComponent:currentTheme];
        path = [path stringByAppendingFormat:@"%@",[imgDico objectForKey:@"location"]];
        UIImage *i = [UIImage imageWithContentsOfFile:path];
        [imgView setImage:i];
       */ 
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        [titleLabel setText:[imgDico objectForKey:@"name"]];
        return cell;
    }
    
    else if (indexPath.section == 1){
        
        NSArray *strArray = [[afThemeManager sharedafThemeManager] stringsForTheme:currentTheme];
        
        NSDictionary *strDico = [strArray objectAtIndex:indexPath.row];
        
        static NSString *CellIdentifier = @"strCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ @ %@",[strDico objectForKey:@"name"],[strDico objectForKey:@"location"]];
        [cell.textLabel setText:str];
        
        [cell.detailTextLabel setText:[strDico objectForKey:@"content"]];
        return cell;
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Images";
        case 1:
            return @"Strings";
    }
    return @"";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
