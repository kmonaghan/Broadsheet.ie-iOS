//
//  Photo.h
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 28/12/2010.
//  Copyright 2010 Crayons and Brown Paper. All rights reserved.
//


@interface Photo : NSObject <TTPhoto> 
{
	NSString *_caption;
	NSString *_urlLarge;
	NSString *_urlSmall;
	NSString *_urlThumb;
	id <TTPhotoSource> _photoSource;
	CGSize _size;
	NSInteger _index;
}

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *urlLarge;
@property (nonatomic, copy) NSString *urlSmall;
@property (nonatomic, copy) NSString *urlThumb;
@property (nonatomic, assign) id <TTPhotoSource> photoSource;
@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger index;

- (id)initWithCaption:(NSString *)caption urlLarge:(NSString *)urlLarge urlSmall:(NSString *)urlSmall urlThumb:(NSString *)urlThumb size:(CGSize)size;

@end
