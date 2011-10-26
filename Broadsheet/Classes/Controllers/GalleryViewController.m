//
//  GalleryViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 28/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryModel.h"
#import "WordPressPost.h"
#import "GalleryDetailViewController.h"

#import "SHK.h"

@implementation GalleryViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPost:(WordPressPost*)post {
	if (self = [super init]) {
		_post = post;
		self.photoSource = [[GalleryModel alloc] initWithPostId:post.postId];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
	CGRect screenFrame = [UIScreen mainScreen].bounds;
	self.view = [[[UIView alloc] initWithFrame:screenFrame] autorelease];
	
	CGRect innerFrame = CGRectMake(0, 0,
								   screenFrame.size.width, screenFrame.size.height);
	_innerView = [[UIView alloc] initWithFrame:innerFrame];
	_innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_innerView];
	
	_scrollView = [[TTScrollView alloc] initWithFrame:screenFrame];
	_scrollView.delegate = self;
	_scrollView.dataSource = self;
	_scrollView.backgroundColor = [UIColor blackColor];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[_innerView addSubview:_scrollView];
	
	_nextButton = [[UIBarButtonItem alloc] initWithImage:
				   TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png")
												   style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
	_previousButton = [[UIBarButtonItem alloc] initWithImage:
					   TTIMAGE(@"bundle://Three20.bundle/images/previousIcon.png")
													   style:UIBarButtonItemStylePlain target:self action:@selector(previousAction)];
	
	_shareButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																  target:self
																  action:@selector(share)] autorelease];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
	
	[button addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
	
	_infoButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	UIBarButtonItem* playButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
									UIBarButtonSystemItemPlay target:self action:@selector(playAction)] autorelease];
	playButton.tag = 1;
	
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	_toolbar = [[UIToolbar alloc] initWithFrame:
				CGRectMake(0, screenFrame.size.height - TT_ROW_HEIGHT,
						   screenFrame.size.width, TT_ROW_HEIGHT)];
	if (self.navigationBarStyle == UIBarStyleDefault) {
		_toolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
	}
	
	_toolbar.barStyle = self.navigationBarStyle;
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
	_toolbar.items = [NSArray arrayWithObjects:
					  space, _infoButton, space, _previousButton, space, _nextButton, space, _shareButton, space, nil];
	[_innerView addSubview:_toolbar];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)share
{
	// Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:_post.postUrl];
	SHKItem *item = [SHKItem URL:url title:_post.title];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromToolbar:self.navigationController.toolbar];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)info
{
	GalleryModel* gallery = (GalleryModel *)self.photoSource;
	
	NSString* html = [NSString stringWithFormat:@"<html><head><link href='default.css' rel='stylesheet' type='text/css' /></head><body><div id='maincontent' class='content'><div class='post'><div id='title'>%@</div><div id='singlentry' class='left-justified'>%@</div></div></div></body></html>",
						  gallery.title,
						  gallery.content];
	
	GalleryDetailViewController *vc = [[GalleryDetailViewController alloc] initWithHtml:html];
	
	
	[self.navigationController pushViewController:vc animated:YES];
	
	[vc release];
}
@end
