//
//  RestaurantDetailViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "ReviewDetailViewController.h"
#import "LocationService.h"
#import "YelpService.h"
#import "AppDelegate.h"
#import "ReviewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Theme.h"
#import "Review.h"
#import "ActivityViewController.h"

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rating;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *totalReviews;
@property (weak, nonatomic) IBOutlet UILabel *openOrClose;
@property (weak, nonatomic) IBOutlet UIView *backgroundImage;
@property (strong, nonatomic) UIBarButtonItem *shareButton;

@property NSArray *reviews;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReviews:) name:@"refreshReviewsMessageEvent" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Init Share Button
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = self.shareButton;
    
    // Init Table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewRestaurantCell" bundle:nil] forCellReuseIdentifier:@"reviewCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Init Map View
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    // Init Restaurant details
    [self.name setText:self.restaurant.business.name];
    [self.totalReviews setText:[NSString stringWithFormat:@"%lu Reviews", (unsigned long)[self.restaurant.business reviewCount]]];
    if (self.restaurant.business.isClosed) {
        [self.openOrClose setText:@"Closed"];
        [self.openOrClose setBackgroundColor:[UIColor redColor]];
    } else {
        [self.openOrClose setText:@"Open"];
        [self.openOrClose setTintColor:[UIColor greenColor]];
    }    
    self.rating.allowsHalfStars = YES;
    self.rating.accurateHalfStars = YES;
    self.rating.value = self.restaurant.business.rating;
    self.rating.shouldBeginGestureRecognizerBlock = nil;
    [self.rating setShouldBecomeFirstResponder:NO];
    [self.rating setUserInteractionEnabled:NO];
    
    // Init Data
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ************************************************************************************************************

#pragma mark Notifications

- (void)refreshReviews:(NSNotification*)notification {
    self.reviews = [[notification object] reviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

// **************************************************************************************************

#pragma mark Data

- (void)initData {
    // Init Restaurant Reviews
    [self getRestaurantReviews];
    
    // Init Restaurant Location
    [self getRestaurantLocation];
    
    // Init Restaurant Hours
    [self getRestaurantHours];
}

- (void)getRestaurantReviews {
    [[YelpService sharedManager]getReviewsForBusiness:self.restaurant.business.identifier];
}

- (void)getRestaurantLocation {
     MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
     CLLocationCoordinate2D pinCoordinate;
     pinCoordinate.latitude = self.restaurant.business.location.coordinate.latitude;
     pinCoordinate.longitude = self.restaurant.business.location.coordinate.longitude;
     myAnnotation.coordinate = pinCoordinate;
     myAnnotation.title = self.restaurant.business.name;
     
     dispatch_async(dispatch_get_main_queue(), ^{
         MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:pinCoordinate fromEyeCoordinate:CLLocationCoordinate2DMake(pinCoordinate.latitude, pinCoordinate.longitude) eyeAltitude:10000];
         [self.mapView setCamera:camera];
         [self.mapView addAnnotation:myAnnotation];
     });
}

- (void)getRestaurantHours {
    [[AppDelegate sharedYelpClient] businessWithId:self.restaurant.business.identifier completionHandler:^
     (YLPBusiness *search, NSError *error) {
         // TODO: Yelp API V3 doesn't provide hours data for iOS yet
     }];
}

// **************************************************************************************************

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *cell = (ReviewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [ReviewCell new];
    }
    
    [cell updateCellWithReview:self.reviews[indexPath.row]];
    
    // Set User Avatar
    __weak ReviewCell *weakCell = cell;
    [[YelpService sharedManager]downloadUserAvatarFromUrl:self.reviews[indexPath.row] forCell:weakCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0f;
}

// **************************************************************************************************

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
}

// **************************************************************************************************

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[ReviewDetailViewController class]]) {
        // Get selected cell row index to get the selected review
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ReviewDetailViewController *vc = segue.destinationViewController;
        Review *review = [Review new];
        review.review = self.reviews[indexPath.row];
        vc.review = review;
    }
}

// ****************************************************************************************************************

#pragma mark - Share

- (IBAction)shareClick:(id)sender {
    [self share];
}

- (void)share {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *shareText = [NSString stringWithFormat:@"Should we book a table at %@ - %@ food, %.1f stars?",
                               self.restaurant.business.name,
                               [[self.restaurant.business.categories firstObject] name],
                               self.restaurant.business.rating];
        
        NSArray *objectsToShare = @[shareText, self.restaurant.image];
        
        ActivityViewController *activityVC = [[ActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        [activityVC setValue:@"Seen on Gentlemen's Wheel" forKey:@"subject"];
        
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeMail,
                                       UIActivityTypePostToTwitter,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo];
        
        activityVC.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    });
}

@end
