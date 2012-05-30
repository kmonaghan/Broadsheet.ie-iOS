//
//  WordPressPostViewController.m
//  TTWordPress
//
//  Created by Karl Monaghan on 26/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//
#import "TTWordPress.h"

#import "WordPressPostViewController.h"
#import "WordPressPostDataSource.h"
#import "WordPressPostModel.h"
#import "WordPressPost.h"
#import "WordPressCommentViewController.h"
#import "WordPressAddCommentViewController.h"
#import "WordPressCategory.h"
#import "WordPressImageViewController.h"

#import "TableItemDisclosure.h"

#import <Three20UICommon/UIViewControllerAdditions.h>

@implementation WordPressPostViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPost:(WordPressPost*)post {
	self = [super initWithNibName:nil bundle:nil];
    
    if (self) 
    {
        self.hidesBottomBarWhenPushed = YES;
        _post = [post retain];
    }
    
	return self;	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPostId:(NSInteger)postId
{
   	self = [super initWithNibName:nil bundle:nil];
    
    if (self) 
    {
		self.hidesBottomBarWhenPushed = YES;
        
        _postId = postId;
    }
    
	return self; 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithApiUrl:(NSString *)url
{
   	self = [super initWithNibName:nil bundle:nil];
    
    if (self) 
    {
		self.hidesBottomBarWhenPushed = YES;
        
        _url = [url retain];
    }
    
	return self; 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel 
{
    if (_post)
    {
        _postLoaded = YES;
        
        self.dataSource = [[[WordPressPostDataSource alloc] initWithPost:_post] autorelease];
    }
    else if (_postId)
    {
        self.dataSource = [[[WordPressPostDataSource alloc] initWithPostId:_postId] autorelease];
    }
    else if (_url)
    {
        self.dataSource = [[[WordPressPostDataSource alloc] initWithApiUrl:_url] autorelease];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc 
{
    TT_RELEASE_SAFELY(_activityView);
    TT_RELEASE_SAFELY(_post);
    TT_RELEASE_SAFELY(_url);
    TT_RELEASE_SAFELY(_postWebView);
    
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showActivity:(BOOL)show 
{
    if (nil == _activityView) 
    {
        _activityView = [[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleWhiteBox];
        
    }
    
    if (show) 
    {
        [self.tableView.tableHeaderView addSubview:_activityView];
        
        _activityView.text = @"Loading content";
        _activityView.frame = CGRectMake(0, 150, 320, 40);
        _activityView.hidden = NO;
    } else {
        [_activityView removeFromSuperview];
        
        _activityView.hidden = YES;
    }
}	

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLoadModel:(BOOL)firstTime 
{
    [super didLoadModel:firstTime];

    if (firstTime || _postLoaded)
    {
        if (_url)
        {
            TT_RELEASE_SAFELY(_url);
        }
        
        if (_postId)
        {
            _postId = 0;
        }
        
        
        WordPressPostModel* post = (WordPressPostModel *)self.dataSource.model;
        
        if (_post)
        {
            TT_RELEASE_SAFELY(_post);
        }
        
        _post = [post.post retain];
        
        _postLoaded = NO;
        
        UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 304)] autorelease];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 303, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        [headerView addSubview:line];
        
        self.tableView.tableHeaderView = headerView;
        
        [line release];
        
        _postWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:WP_POST_DATE_FORMAT];
        
        NSString* postHtml = [NSString stringWithFormat:@"<html><head><script type='text/javascript'>window.onload = function() {window.location.href = 'ready://' + document.body.offsetHeight;}</script><link href='default.css' rel='stylesheet' type='text/css' /></head><body><div id='maincontent' class='content'><div class='post'><div id='title'>%@ <span class='date-color'>%@</span></div><div id='singlentry'>%@</div></div></div></body></html>",
                              post.post.title,
                              [df stringFromDate:post.post.postDate],
                              post.post.content];
        
        [df release];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        [_postWebView loadHTMLString:postHtml baseURL:baseURL];
        
        _postWebView.delegate = self;
        
        [self.tableView insertSubview:_postWebView aboveSubview:self.tableView.tableHeaderView];
        
        [self showActivity:YES];
    } 
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resizeWebView:(CGFloat)height
{
    CGFloat newHeight = 0;
    
    if (height == 0)
    {
        CGSize webViewSize = [_postWebView sizeThatFits:CGSizeZero];
    
        newHeight = (webViewSize.height > 294) ? webViewSize.height : 304;
    }
    else
    {
        newHeight = height;
    }
    
    newHeight += 5;
    
    NSLog(@"newHeight: %f", newHeight);
    
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, newHeight + 2)];
	headerView.opaque = NO;
    headerView.backgroundColor = [UIColor clearColor];
	[headerView setAlpha:0];
    
    _postWebView.frame = CGRectMake(0, 0, 320, newHeight);
    
	for (id subview in _postWebView.subviews){
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
		{
			((UIScrollView *)subview).bounces = NO;
			((UIScrollView *)subview).scrollsToTop = NO;
			((UIScrollView *)subview).scrollEnabled = NO;
		}
	}	
    
    if (height)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, newHeight+1, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
    
        [_postWebView addSubview:line];
        
        [line release];
    }
    
	self.tableView.tableHeaderView = headerView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"[[request URL] scheme]: %@", [[request URL] absoluteString]);
    
    if (navigationType == UIWebViewNavigationTypeOther) {
        if ([[[request URL] scheme] isEqualToString:@"ready"]) 
        {
            [self resizeWebView:[[[request URL] host] floatValue]];
            
            return NO;
        }
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
        NSArray *parts = [[[request URL] absoluteString] componentsSeparatedByString:@"."];
        
        NSString *ext = [[parts lastObject] lowercaseString];
        
        if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"] 
            || [ext isEqualToString:@"png"]
            || [ext isEqualToString:@"gif"])
        {
            //NSLog(@"captured image: %@", [[request URL] absoluteString]);
            
            WordPressImageViewController* commentview = [[WordPressImageViewController alloc] initWithUrl:[[request URL] absoluteString]];
			[self.navigationController pushViewController:commentview animated:YES];
			[commentview release];
        }
        else
        {
            [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[[request URL] absoluteString]] applyAnimated:YES]];
        }
        
		return NO;
	}
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView *)webView 
{	
    [self showActivity:NO];
	
    [self resizeWebView:0.0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) makePost
{
    WordPressPostModel* post = (WordPressPostModel *)self.dataSource.model;
    
    WordPressAddCommentViewController *controller = [[[WordPressAddCommentViewController alloc] initWithPost:post.post withTarget:self] autorelease];
    UIViewController *topController = [TTNavigator navigator].topViewController; 
    controller.delegate = controller; 
    topController.popupViewController = controller;
    controller.superController = topController; 
    
    [controller showInView:controller.view animated:YES]; 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    WordPressPostModel* post = (WordPressPostModel *)self.dataSource.model;
    
	if (indexPath.row == 0)
	{
		if (post.post.commentCount > 0)
		{
			WordPressCommentViewController* commentview = [[WordPressCommentViewController alloc] initWithPost:post.post];
			[self.navigationController pushViewController:commentview animated:YES];
			[commentview release];
		}
		else 
		{
            [self makePost];
		}

		return;
	}
    else if ([post.post.commentStatus isEqualToString:@"open"] && (indexPath.row == 1) && (post.post.commentCount > 0))
    {
        [self makePost]; 
    }
	else 
	{
		[super didSelectObject:object atIndexPath:indexPath];
	}
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewNetworkEnabledDelegate alloc] initWithController:self 
                                                          withDragRefresh:YES 
                                                       withInfiniteScroll:NO] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadComments
{
    _postLoaded = YES;
    
    self.dataSource = [[[WordPressPostDataSource alloc] initWithPost:_post] autorelease];
    [self updateView];
}
@end
