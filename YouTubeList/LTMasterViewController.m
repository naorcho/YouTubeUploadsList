//
//  LTMasterViewController.m
//  YouTubeList
//
//  Created by SalesTech on 3/27/13.
//  Copyright (c) 2013 SalesTech. All rights reserved.
//

#import "LTMasterViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LTDetailViewController.h"
#import "HCYoutubeParser.h"


/////////////////////////////////////////
@interface LTMasterViewController (PrivateMethods)

- (GDataServiceGoogleYouTube *)youTubeService;

@end

@implementation LTMasterViewController

@synthesize feed = _feed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    
    
    
    // get the youtube service
    GDataServiceGoogleYouTube *service = [self youTubeService];

    // feed id for user uploads
    NSString *uploadsID = kGDataYouTubeUserFeedIDUploads;
    // construct the feed url
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForUserID:kGDataServiceDefaultUser
                                                         userFeedID:uploadsID];
    // make API call
    [service fetchFeedWithURL:feedURL
                     delegate:self
            didFinishSelector:@selector(request:finishedWithFeed:error:)];
    
    [super viewDidLoad];
}

- (void)request:(GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedBase *)aFeed
          error:(NSError *)error {
    
    self.feed = (GDataFeedYouTubeVideo *)aFeed;
    NSLog(@"FEED:%@", [self.feed entries]);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.feed entries] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    // Configure the cell.
    GDataEntryBase *entry = [[_feed entries] objectAtIndex:indexPath.row];
    NSString *title = entry.title.stringValue;
//    NSArray *thumbnails = [[(GDataEntryYouTubeVideo *)entry mediaGroup] mediaThumbnails];
    
    cell.textLabel.text = title;
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[thumbnails objectAtIndex:0] URLString]]];
//    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    GDataEntryBase *entry = [[_feed entries] objectAtIndex:indexPath.row];

//    NSURL *url = [NSURL URLWithString:_urlTextField.text];
    NSLog(@"LINK: %@", [[entry.links objectAtIndex:0] valueForKey:@"href"]);
    NSString *urlString = [[entry.links objectAtIndex:0] valueForKey:@"href"];
    urlString = [urlString substringToIndex:[urlString rangeOfString:@"&feature="].location];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *qualities = [HCYoutubeParser h264videosWithYoutubeURL:url];
    
    NSURL *urlToLoad = [NSURL URLWithString:[qualities objectForKey:@"medium"]];
    
//    NSURL *urlToLoad = [NSURL URLWithString:[[entry.links objectAtIndex:0] valueForKey:@"href"]];
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:urlToLoad];
    [self presentModalViewController:mp animated:YES];
//    [self presentMoviePlayerViewControllerAnimated:mp]; // ios 6
}

#pragma mark - YouTube Methods

- (GDataServiceGoogleYouTube *)youTubeService {
    static GDataServiceGoogleYouTube* _service = nil;
    
    if (!_service) {
        _service = [[GDataServiceGoogleYouTube alloc] init];
        
        [_service setUserAgent:@"AppWhirl-UserApp-1.0"];
        [_service setShouldCacheResponseData:YES];
        [_service setServiceShouldFollowNextLinks:NO];
    }
    
//    NSString *devKey = @"AI39si4RhsDO7ULQftKKiqhWTrx7Aagmt7YQD-VTSFrCTwhisZRmUbB-0pnLnHAba8ODe_yxVhLcTMPmKHhQpvozGrfSX9EEYQ";
//    [_service setYouTubeDeveloperKey:devKey];
    // fetch unauthenticated
    [_service setUserCredentialsWithUsername:@"YOUR_USER_NAME" password:@"YOUR_PASS"];
    
    return _service;
}

@end
