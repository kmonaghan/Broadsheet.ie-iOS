//
//  SubmitTipViewController.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 04/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#import "SubmitTipViewController.h"
#import "TTWordPress.h"
#import "UIImage+Resize.h"

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

        _images = [[NSMutableArray arrayWithCapacity:1] retain];
        
        _picker = [[[UIImagePickerController alloc] init] retain];
        _picker.delegate = self;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	TT_RELEASE_SAFELY(_postParams);
	
    TT_RELEASE_SAFELY(_images);
    TT_RELEASE_SAFELY(_imageToSubmit); 
    TT_RELEASE_SAFELY(_picker);
    
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) initCells {
	if (nameField == nil)
	{
		nameField = [[UITextField alloc] init];
		nameField.placeholder = @"Your name";
		nameField.returnKeyType = UIReturnKeyNext;
		nameField.delegate = self;
		nameField.font = TTSTYLEVAR(font);
		
		emailfield = [[UITextField alloc] init];
		emailfield.placeholder = @"Your email";
		emailfield.returnKeyType = UIReturnKeyNext;
		emailfield.keyboardType = UIKeyboardTypeEmailAddress;
		emailfield.delegate = self;
		emailfield.font = TTSTYLEVAR(font);
		
		message = [[[UITextView alloc] init] autorelease];
		message.text = @"Your message";
		message.returnKeyType = UIReturnKeyDefault;
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
- (void)createFooter {
	//allocate the view if it doesn't exist yet
	UIView *footerView  = [[UIView alloc] init];
	
    CGFloat top = 0;
    
    if ([_images count])
    {
        UIImage *thumbimage = [[_images objectAtIndex:0] thumbnailImage:100
                                                      transparentBorder:0
                                                           cornerRadius:0
                                                   interpolationQuality:kCGInterpolationHigh];
        
        if (_imageToSubmit)
        {
            TT_RELEASE_SAFELY(_imageToSubmit);
        }
        
        _imageToSubmit = [[UIImageView alloc] initWithFrame:CGRectMake(110,16,100,100)];
        [footerView addSubview:_imageToSubmit];
        
        _imageToSubmit.image = thumbimage;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(194, 0, 32, 32)];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:button];
        
        top += 116;
    }
    else
    {
        UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        pictureButton.imageView.image = [UIImage imageNamed:@"86-camera.png"];
        [pictureButton setFrame:CGRectMake(10, 3, 300, 44)];
        [pictureButton addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *camera = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"86-camera.png"]];
        camera.frame = CGRectMake(138, 13, 24, 18);
        [pictureButton addSubview:camera];
        
        [camera release];
        [footerView addSubview:pictureButton];
        
        top += 50;
    }
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:[[UIImage imageNamed:@"green-button.png"]
                                stretchableImageWithLeftCapWidth:8 topCapHeight:8] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"green-button-highlight.png"]
                                stretchableImageWithLeftCapWidth:8 topCapHeight:8] forState:UIControlStateHighlighted];
	[button setFrame:CGRectMake(10, top, 300, 44)];
	[button setTitle:@"Send" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(submitTip) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[footerView addSubview:button];
    
    [footerView setFrame:CGRectMake(0, 0, 320, (top + 50))];
    
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
    /*
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(cancel)];
     */
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
    if (textField == nameField)
    {
        [emailfield becomeFirstResponder];
    }
    else
    {
        [message becomeFirstResponder];
    }
	
	//[self cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    /*
    [textField resignFirstResponder];
	[self cancel];
	*/
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
							 requestWithURL: [NSString stringWithFormat:@"%@iphone_tip.php", WP_BASE_URL]
							 delegate: self];
	
	request.cachePolicy = TTURLRequestCachePolicyNoCache; 
	
	request.httpMethod = @"POST";
	
	for (NSString* param in _postParams) 
	{
		[request.parameters setObject:[_postParams objectForKey:param] forKey:param];
	}
	
    int i = 0;
    
    for (UIImage *image in _images) 
    {
        [request addFile:UIImagePNGRepresentation(image) 
                mimeType:@"image/png" 
                fileName:[NSString stringWithFormat:@"photo_%d.png", i]];
        i++;
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
	
	//NSLog(@"Returned from server: %@", feed);
	
	if ([[feed objectForKey:@"status"] intValue] == 1) 
    {
		if ([feed objectForKey:@"response"])
		{
			[self submitResult:[feed objectForKey:@"response"]];
		}
	} 
    else 
    {
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
	[self loadError];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)photo
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [actionSheet addButtonWithTitle:@"Take Photo"];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [actionSheet addButtonWithTitle:@"From Photo Library"];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        [actionSheet addButtonWithTitle:@"From Album"];
    }
    
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)displayPicker:(UIImagePickerControllerSourceType)source
{
    _picker.sourceType = source;

    [self presentModalViewController:_picker animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker 
{
    [self dismissModalViewControllerAnimated: YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {    
    [self dismissModalViewControllerAnimated: YES];
    
    // Get the selected image.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_images addObject:[image resizedImage:CGSizeMake(image.size.width / 2, image.size.height / 2) 
                      interpolationQuality:kCGInterpolationHigh]];
    
    [self createFooter];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType source;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"])
    {
        source = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"From Photo Library"])
    {
        source = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"From Album"])
    {
        source = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        return;
        
    }
    
    [self displayPicker:(UIImagePickerControllerSourceType)source];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeImage
{
    [_images removeAllObjects];
    
    [self createFooter];
}
@end
