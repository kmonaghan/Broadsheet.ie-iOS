//
//  VideoListViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 22/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#import "VideoListViewController.h"
#import "WordPressDataSource.h"

@implementation VideoListViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.variableHeightRows = YES;
		
		self.title = @"Video";
		
		UIImage* image = [UIImage imageNamed:@"45-movie-1.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Video" image:image tag:12348] autorelease];
		
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	self.dataSource = [[[WordPressDataSource alloc] initWithUrl:@"http://broadsheet.ie/?json=get_category_posts&id=3061"] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show
{
	self.navigationItem.rightBarButtonItem = nil;
	
	[super showLoading:show];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showError:(BOOL)show
{
	[super showError:show];	
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(tryReload)];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) tryReload
{
	self.navigationItem.rightBarButtonItem = nil;
	
	[self invalidateModel];
}

@end
