//
//  GalleryModel.m
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 28/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//

#import "GalleryModel.h"
#import "Photo.h"
#import <extThree20JSON/extThree20JSON.h>

@implementation GalleryModel

@synthesize postId = _postId;
@synthesize title = _title;
@synthesize content = _content;
@synthesize photos = _photos;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPostId:(NSInteger)postId
{
	if (self = [super init]) {
		_postId = postId;
		
		_url = [NSString stringWithFormat:@"http://broadsheet.ie/broadsheet_gallery.php?id=%d", _postId];
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	TT_RELEASE_SAFELY(_title);
	TT_RELEASE_SAFELY(_content);
	TT_RELEASE_SAFELY(_photos);
	TT_RELEASE_SAFELY(_url);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (!self.isLoading) {
		TTURLRequest* request = [TTURLRequest
								 requestWithURL: _url
								 delegate: self];
		
		request.cachePolicy = cachePolicy;
		//request.cacheExpirationAge = TT_DEFAULT_CACHE_INVALIDATION_AGE;
		request.cacheExpirationAge = 0;
		
		TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
		request.response = response;
		TT_RELEASE_SAFELY(response);
		
		[request send];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) processResponse:(NSDictionary*) response {

	NSArray* entries = [[response objectForKey:@"data"] objectForKey:@"images"];
	
	_title = [[[response objectForKey:@"data"] objectForKey:@"post_title"] copy];
	_content = [[[response objectForKey:@"data"] objectForKey:@"post_content"] copy];
	
	_photos = [[NSMutableArray alloc] init];
	
	int i = 0;
	for (NSDictionary* entry in entries) {
		Photo* photo = [[Photo alloc] initWithCaption:[entry objectForKey:@"description"] 
											urlLarge:[entry objectForKey:@"filename"] 
											urlSmall:[entry objectForKey:@"thumb"] 
											urlThumb:[entry objectForKey:@"thumb"] 
												size:(CGSize)CGSizeMake([[entry objectForKey:@"width"] intValue], [[entry objectForKey:@"height"] intValue])];
		
		photo.photoSource = self;
        photo.index = i;
		i++;

		[_photos addObject:photo];
		TT_RELEASE_SAFELY(photo);
	 	
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) showError:(NSDictionary*) response {	
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: @"Error"
							   message: [response objectForKey:@"message"]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
	
	NSDictionary* feed = response.rootObject;
	
	if ([[feed objectForKey:@"status"] intValue] == 1) {
		[self processResponse:[feed objectForKey:@"response"]];
		
	} else {
		[self showError:[feed objectForKey:@"response"]];
	}
	
	[super requestDidFinishLoad:request];
}

#pragma mark TTPhotoSource
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPhotos 
{
    return _photos.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)maxPhotoIndex
{
    return _photos.count - 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
	if (photoIndex < _photos.count) {
		id photo = [_photos objectAtIndex:photoIndex];
		if (photo == [NSNull null]) {
			return nil;
		} else {
			
			return photo;
		}
	} else {
		return nil;
	}
}
@end
