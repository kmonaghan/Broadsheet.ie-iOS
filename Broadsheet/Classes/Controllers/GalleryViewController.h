//
//  GalleryViewController.h
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 28/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//
@class WordPressPost;

@interface GalleryViewController : TTPhotoViewController {
	WordPressPost*	_post;
	
	UIBarButtonItem* _shareButton;
	UIBarButtonItem* _infoButton;
}

- (id)initWithPost:(WordPressPost*)post;

@end
