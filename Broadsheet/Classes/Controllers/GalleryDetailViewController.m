//
//  GalleryDetailViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 04/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#import "GalleryDetailViewController.h"


@implementation GalleryDetailViewController
-(void)dismissMe: (id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (id)initWithHtml:(NSString *)html
{
	if (self = [super initWithNibName:nil bundle:nil])
	{
		self.navigationBarStyle = UIBarStyleBlackOpaque;
		//self.navigationBarTintColor = nil;
		
		CGRect webFrame = [[UIScreen mainScreen] applicationFrame];  
		UIWebView* web = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];  
		web.backgroundColor = [UIColor whiteColor];
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path];

		[web loadHTMLString:html baseURL:baseURL];
		[self.view addSubview:web];
	}
	
	return self;
}
@end
