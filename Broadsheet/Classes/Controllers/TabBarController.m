//
//  TabBarController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 26/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

#import "TabBarController.h"
#import <Three20UI/UITabBarControllerAdditions.h>

@implementation TabBarController

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:
					  kBlogURL,
					  kGalleryURL,
					  kVideoURL,
					  kSubmitTipURL,
					  kAboutURL,
					  nil]];
}

@end
