//
//  SubmitTipViewController.h
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 04/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SubmitTipViewController : BaseTableViewController <UITextFieldDelegate, 
                                                                UITextViewDelegate, 
                                                                TTURLRequestDelegate,
                                                                UIImagePickerControllerDelegate, 
                                                                UINavigationControllerDelegate,
                                                                UIActionSheetDelegate> {
	UITextField*	nameField;
	UITextField*	emailfield;
	UITextView*		message;
    
	NSMutableDictionary* _postParams;
	
	TTURLRequest*	_request;
    
    NSMutableArray  *_images;
    UIImageView     *_imageToSubmit; 
    UIImagePickerController *_picker;
}

- (void)send;

@end
