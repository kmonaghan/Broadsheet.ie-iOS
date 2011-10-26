//
//  AboutViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 27/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {		
		self.title = @"About";
		
		UIImage* image = [UIImage imageNamed:@"59-info.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"About" image:image tag:12350] autorelease];
		
		CGRect webFrame = [[UIScreen mainScreen] applicationFrame];  
		UIWebView* web = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];  
		web.backgroundColor = [UIColor whiteColor];

		[web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"] isDirectory:NO]]];
		
		[self.view addSubview:web];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[super dealloc];
}
@end
