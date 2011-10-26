//
//  BroadsheetWordPress.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 22/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#import "BroadsheetWordPress.h"
#import "WordPressPost.h"
#import "GalleryViewController.h"
#import "WordPressCategory.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BroadsheetWordPress
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		UIImage *navimage;

		NSDate *today = [NSDate date]; 
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEE"];
		if (![[dateFormat stringFromDate:today] isEqualToString:@"Fri"])
		{
			navimage = [UIImage imageNamed: @"broadsheet_black.png"];
		}
		else 
		{
			navimage = [UIImage imageNamed: @"broadsheet_colour.png"];
		}

		[dateFormat release];
		
		UIImageView *imageview = [[UIImageView alloc] initWithImage:navimage];
		
		// set the text view to the image view
		self.navigationItem.titleView = imageview;
		
		[imageview release];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isSlideShow:(WordPressPost *)post
{
	for (WordPressCategory* category in post.categories)
	{
		if (category.categoryId == 18)
		{
			return YES;
		}
	}	
	
	return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
	if([object isKindOfClass:[WordPressPost class]])
	{
		WordPressPost* post = object;
		
		if ([self isSlideShow:post])
		{
			GalleryViewController* postview = [[GalleryViewController alloc] initWithPost:object];
			[self.navigationController pushViewController:postview animated:YES];
			[postview release];
			
			return;
		}
	}

	[super didSelectObject:object atIndexPath:indexPath];
	
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
