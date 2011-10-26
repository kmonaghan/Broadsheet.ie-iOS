//
//  GalleryListViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 27/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

#import "GalleryListViewController.h"

#import "WordPressDataSource.h"
#import "GalleryViewController.h"
#import "WordPressPost.h"

@implementation GalleryListViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.variableHeightRows = YES;
		
		self.title = @"Slide Shows";
		
		UIImage* image = [UIImage imageNamed:@"42-photos.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Slide Shows" image:image tag:12348] autorelease];
		
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	self.dataSource = [[[WordPressDataSource alloc] initWithUrl:@"http://broadsheet.ie/?json=get_category_posts&id=18"] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
	if([object isKindOfClass:[WordPressPost class]])
	{
		GalleryViewController* postview = [[GalleryViewController alloc] initWithPost:object];
		[self.navigationController pushViewController:postview animated:YES];
		[postview release];
	}
	else 
	{
		[super didSelectObject:object atIndexPath:indexPath];
	}
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewNetworkEnabledDelegate alloc] initWithController:self withDragRefresh:YES withInfiniteScroll:YES] autorelease];
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
