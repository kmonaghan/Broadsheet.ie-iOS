//
//  AppDelegate.m
//  Broadsheet
//
//  Created by Karl Monaghan on 26/10/2011.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarController.h"

#import "BroadsheetWordPress.h"
#import "WordPressAddCommentViewController.h"
#import "GalleryListViewController.h"
#import "VideoListViewController.h"
#import "SubmitTipViewController.h"
#import "AboutViewController.h"

#import "Appirater.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	
	[map from:@"*" toViewController:[TTWebController class]];
	
	[map from:kAppTabBarPath toSharedViewController:[TabBarController class]];
	
	[map from:kBlogURL toSharedViewController:[BroadsheetWordPress class]];
	[map from:kAuthorPostsURL toSharedViewController:[WordPressBlogViewController class]];
	[map from:kCategoryPostsURL toSharedViewController:[WordPressBlogViewController class]];
	[map from:kMakeCommentURL toModalViewController:[WordPressAddCommentViewController class]];
    [map from:kGalleryURL toSharedViewController:[GalleryListViewController class]];
	[map from:kVideoURL toSharedViewController:[VideoListViewController class]];
	[map from:kSubmitTipURL toSharedViewController:[SubmitTipViewController class]];
	[map from:kAboutURL toSharedViewController:[AboutViewController class]];
	

	[navigator openURLAction:[TTURLAction actionWithURLPath:kAppTabBarPath]];
    
	[Appirater appLaunched];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
