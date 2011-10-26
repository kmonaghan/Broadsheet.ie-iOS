//
//  BaseTableViewController.m
//  WeddingPhotoGallery
//
//  Created by Karl Monaghan on 15/09/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

#import "BaseTableViewController.h"


@implementation BaseTableViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	//	self.navigationBarTintColor = [UIColor blackColor];
	//	self.statusBarStyle = UIStatusBarStyleBlackOpaque;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

@end
