//
//  SubmitTipViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 04/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#import "SubmitTipViewController.h"

#import <extThree20JSON/extThree20JSON.h>
#import <extThree20JSON/NSObject+SBJSON.h>

@implementation SubmitTipViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = @"Submit Tip";
		
		UIImage* image = [UIImage imageNamed:@"18-envelope.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Submit Tip" image:image tag:12349] autorelease];
		
		self.tableViewStyle = UITableViewStyleGrouped;
		self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;

	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	TT_RELEASE_SAFELY(_postParams);
	
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) initCells {
	if (nameField == nil)
	{
		nameField = [[UITextField alloc] init];
		nameField.placeholder = @"Your name";
		nameField.returnKeyType = UIReturnKeyDone;
		nameField.delegate = self;
		nameField.font = TTSTYLEVAR(font);
		
		emailfield = [[UITextField alloc] init];
		emailfield.placeholder = @"Your email";
		emailfield.returnKeyType = UIReturnKeyDone;
		emailfield.keyboardType = UIKeyboardTypeEmailAddress;
		emailfield.delegate = self;
		emailfield.font = TTSTYLEVAR(font);
		
		message = [[[UITextView alloc] init] autorelease];
		message.text = @"Your message";
		message.returnKeyType = UIReturnKeyDone;
		message.delegate = self;
		message.font = TTSTYLEVAR(font);
			
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	[self initCells];
	
	self.dataSource = [TTListDataSource dataSourceWithObjects:
					   nameField,
					   emailfield,
					   message,
					   nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) createFooter {
	//allocate the view if it doesn't exist yet
	UIView* footerView  = [[UIView alloc] init];
	[footerView setFrame:CGRectMake(0, 0, 320, 44)];
	
	//we would like to show a gloosy red button, so get the image first
	UIImage *image = [[UIImage imageNamed:@"green-button.png"]
					  stretchableImageWithLeftCapWidth:8 topCapHeight:8];
	UIImage *highlightImage = [[UIImage imageNamed:@"green-button-highlight.png"]
							   stretchableImageWithLeftCapWidth:8 topCapHeight:8];
	//create the button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
	
	//the button should be as big as a table view cell
	[button setFrame:CGRectMake(10, 3, 300, 44)];
	
	//set title, font size and font color
	[button setTitle:@"Let us know" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(submitTip) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[footerView addSubview:button];
	
	self.tableView.tableFooterView = footerView;	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)loadView 
{ 	
	[super loadView];
	
	[self createFooter];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cancel
{
	[nameField resignFirstResponder];
	[emailfield resignFirstResponder];
	[message resignFirstResponder];
	
	self.navigationItem.leftBarButtonItem = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(cancel)];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextField *)textField
{
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(cancel)];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
	[textField resignFirstResponder];
	[self cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
	[self cancel];
	
	return YES;	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView
{
	[textView resignFirstResponder];
	[self cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL) validateDetails
{
	NSMutableArray* errorList = [[NSMutableArray alloc] init];
	BOOL valid = YES;
	
	if (!TTIsStringWithAnyText(nameField.text))
	{
		[errorList addObject:@"We'd like to know your name"];
	}
	
	if (!TTIsStringWithAnyText(emailfield.text))
	{
		[errorList addObject:@"We'd like an email address"];
	}
	
	if (!TTIsStringWithAnyText(message.text) || ([message.text isEqualToString:@"Your message"]))
	{
		[errorList addObject:@"You've not told us anything!"];
	}
	
	if ([errorList count] > 0)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Input Error" 
														message:[NSString stringWithFormat:@"Please fix the following error(s):\n%@", [errorList componentsJoinedByString:@"\n"]] 
													   delegate:nil 
											  cancelButtonTitle:@"Okay"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		valid = NO;
	}
	
	[errorList release];
	
	return valid;	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)submitTip
{	
	if ([self validateDetails])
	{
		TTActivityLabel* activityLabel = [[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBezel];
		activityLabel.text = @"Submitting...";
		[activityLabel sizeToFit];
		activityLabel.frame = CGRectMake(0, 0, 320, 375);
		[self.view addSubview:activityLabel];
		
		[self send];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) submitResult:(NSDictionary *) response {
	if ([[self.view.subviews lastObject] isKindOfClass:[TTActivityLabel class]])
	{
		[[self.view.subviews lastObject] removeFromSuperview];
	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" 
													message:[response objectForKey:@"message"] 
												   delegate:nil 
										  cancelButtonTitle:@"Okay"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) submitError:(NSDictionary *) response
{
	if ([[self.view.subviews lastObject] isKindOfClass:[TTActivityLabel class]])
	{
		[[self.view.subviews lastObject] removeFromSuperview];
	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Submission Error" 
													message:[response objectForKey:@"message"] 
												   delegate:nil 
										  cancelButtonTitle:@"Okay"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:(BOOL)animated];
	
	if (self.tableView.tableFooterView == nil)
	{
		[self createFooter];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadError
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Load Error" 
													message:@"There was a problem loading the content" 
												   delegate:nil 
										  cancelButtonTitle:@"Okay"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) send {	
    _postParams = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:nameField.text, 
                                                           emailfield.text,
                                                           message.text,
                                                           nil] 
                                                  forKeys:[NSArray arrayWithObjects:@"name", @"email", @"message", nil]];
    
	TTURLRequest* request = [TTURLRequest
							 requestWithURL: @"http://www.broadsheet.ie/iphone_tip.php"
							 delegate: self];
	
	request.cachePolicy = TTURLRequestCachePolicyNoCache; 
	
	request.httpMethod = @"POST";
	
	for (NSString* param in _postParams) 
	{
		[request.parameters setObject:[_postParams objectForKey:param] forKey:param];
	}
	
	TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
	request.response = response;
	TT_RELEASE_SAFELY(response);
    
	[request send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
	
	NSDictionary* feed = response.rootObject;
	
	NSLog(@"Returned from server: %@", feed);
	
	if ([[feed objectForKey:@"status"] intValue] == 1) {
		if ([feed objectForKey:@"response"])
		{
			[self submitResult:[feed objectForKey:@"response"]];
		}
	} else {
		if ([feed objectForKey:@"response"])
		{
			[self submitError:[feed objectForKey:@"response"]];
		}
		else
		{
			[self submitError:feed];
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	
	TTURLJSONResponse* response = request.response;
	
	NSDictionary* feed = response.rootObject;
	
	[self loadError];
}
@end
