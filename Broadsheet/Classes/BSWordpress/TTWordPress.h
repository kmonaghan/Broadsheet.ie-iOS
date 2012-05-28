//
//  TTWordPress.h
//  Broadsheet.ie
//
//  Created by Karl Monaghan on 20/01/2011.
//  Copyright 2011 Crayons and Brown Paper. All rights reserved.
//

#define WP_BASE_URL				@"http://broadsheet.ie/"

#define WP_POST_LIST_TITLE		@"Posts";
#define WP_POST_LIST_BAR_TITLE	@"Latest"

#define WP_POST_DATE_FORMAT		@"h:mm a, MMMM d, yyyy"

#define WP_COMMENT_DATE_FORMAT	@"MMMM d, yyyy"

#define WP_NAVIGATION_BAR		nil;
#define WP_STATUS_BAR			UIStatusBarStyleDefault;

/**
 *  If you are only displaying extracts on a post list page, set this to
 *  YES so the app knows to retrieve the full post from the site.
 */
#define WP_LOAD_POST            NO