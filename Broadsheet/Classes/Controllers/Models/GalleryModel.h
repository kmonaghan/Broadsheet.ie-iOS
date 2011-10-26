//
//  GalleryModel.h
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 28/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

@interface GalleryModel : TTURLRequestModel <TTPhotoSource> {
    NSInteger		_postId;
	NSString*		_title;
	NSString*		_content;
    NSMutableArray*	_photos;
	
	NSString*		_url;
}

@property (nonatomic) NSInteger			postId;
@property (nonatomic, copy) NSString*			title;
@property (nonatomic, copy) NSString*			content;
@property (nonatomic, retain) NSMutableArray*	photos;

- (id)initWithPostId:(NSInteger)postId;

@end