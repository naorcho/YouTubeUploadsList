//
//  LTMasterViewController.h
//  YouTubeList
//
//  Created by SalesTech on 3/27/13.
//  Copyright (c) 2013 SalesTech. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "GData.h"

#import "GDataYouTube.h"
#import "GDataServiceGoogleYouTube.h"

@class LTDetailViewController;

@interface LTMasterViewController : UITableViewController
{
    GDataFeedYouTubeVideo *_feed;
}

@property (strong, nonatomic) LTDetailViewController *detailViewController;
@property (nonatomic, retain) GDataFeedYouTubeVideo *feed;

@end
