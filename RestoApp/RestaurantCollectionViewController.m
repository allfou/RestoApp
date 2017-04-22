//
//  RestaurantCollectionViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "RestaurantCollectionViewController.h"
#import "RestaurantDetailViewController.h"
#import "RestaurantCell.h"
#import "LocationService.h"
#import "YelpService.h"
#import "YLPClient.h"
#import "YLPSearch.h"
#import "Restaurant.h"
#import "Theme.h"

@interface RestaurantCollectionViewController ()

@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSArray *restaurants;
@property UIImageView *logo;
@property BOOL currentListViewMode;
@property BOOL isRefreshing;

@end

@implementation RestaurantCollectionViewController

static NSString * const listCellID = @"listCell";
static NSString * const detailCellID = @"detailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRestaurantList:) name:@"refreshRestaurantListMessageEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentLocationUpdated:) name:@"currentLocationUpdatedMessageEvent" object:nil];
    
    // Init Navigation Bar (Logo)
    self.logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"nav_logo.png"]];
    self.tabBarController.navigationItem.titleView = self.logo;
    
    // Init Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = refreshControllerColor;
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    self.isRefreshing = NO;
    
    // Init CollectionView
    self.currentListViewMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"listViewMode"];
    [self setCollectionMode:self.currentListViewMode];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0); // unhide last cell from tabbar

    // Init Location Service
    [[LocationService sharedManager]startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Bug with refreshcontrol being position above cells
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

// ************************************************************************************************************

#pragma mark Notifications

- (void)refreshRestaurantList:(NSNotification*)notification {
    self.restaurants = [notification object];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)currentLocationUpdated:(NSNotification*)notification {
    NSString *currentLocation = [NSString stringWithFormat:@"%@", [notification object]];
    
    // Update List of Restaurant at Location
    [[YelpService sharedManager] getNearByRestaurantsForLocation:currentLocation];
}

- (void)initData {
    [[LocationService sharedManager]startUpdatingLocation];
}

// ************************************************************************************************************

#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.restaurants count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantCell *cell;
    
    if (self.currentListViewMode) {
        cell = (RestaurantCell*) [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    } else {
        cell = (RestaurantCell*) [collectionView dequeueReusableCellWithReuseIdentifier:detailCellID forIndexPath:indexPath];
    }
    
    if (!cell) {
        cell = [[RestaurantCell alloc]init];
    }
    
    // Set Restaurant Info
    [cell updateCellWithBusiness:self.restaurants[indexPath.row]];
    
    // Set Restaurant Image
    __weak RestaurantCell *weakCell = cell;
    [[YelpService sharedManager]downloadImageFromUrl:[self.restaurants[indexPath.row] business].imageURL forCell:weakCell];
    
    return cell;
}

// ************************************************************************************************************

#pragma mark CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (void)setCollectionMode:(BOOL)animated {
    UINib *restaurantCellNib;
    
    if (self.currentListViewMode) {
        restaurantCellNib = [UINib nibWithNibName:@"ListRestaurantCell" bundle:nil];
        [self.collectionView registerNib:restaurantCellNib forCellWithReuseIdentifier:listCellID];
        
        if (animated) [self.collectionView reloadData];
        
        __block UICollectionViewFlowLayout *flowLayout;
        
        [self.collectionView performBatchUpdates:^{
            float width;
            CGSize mElementSize;
            [self.collectionView.collectionViewLayout invalidateLayout];
            width = self.collectionView.frame.size.width / 1;
            mElementSize = CGSizeMake(width, 155);
            flowLayout = [[UICollectionViewFlowLayout alloc] init];
            [flowLayout setItemSize:mElementSize];
            flowLayout.minimumLineSpacing = 10.0f;
            flowLayout.minimumInteritemSpacing = 0.0f;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.collectionView setCollectionViewLayout:flowLayout animated:NO];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        restaurantCellNib = [UINib nibWithNibName:@"DetaiRestaurantCell" bundle:nil];
        [self.collectionView registerNib:restaurantCellNib forCellWithReuseIdentifier:detailCellID];
        
        if (animated) [self.collectionView reloadData];
        
        __block UICollectionViewFlowLayout *flowLayout;
        [self.collectionView performBatchUpdates:^{
            float width;
            CGSize mElementSize;
            [self.collectionView.collectionViewLayout invalidateLayout];
            width = self.collectionView.frame.size.width / 1;
            mElementSize = CGSizeMake(width, 297);
            flowLayout = [[UICollectionViewFlowLayout alloc] init];
            [flowLayout setItemSize:mElementSize];
            flowLayout.minimumLineSpacing = 0.0f;
            flowLayout.minimumInteritemSpacing = 0.0f;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.collectionView setCollectionViewLayout:flowLayout animated:NO];
        } completion:^(BOOL finished) {
            
        }];
    }
}

//*****************************************************************************************************************************************

#pragma mark - Refresh Control

- (void)pullToRefresh {
    // Improve refresh UI effect
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isRefreshing = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self containingScrollViewDidEndDragging:scrollView];
    
    if (self.isRefreshing) {
        [self initData];
    }
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView {
    CGFloat minOffsetToTriggerRefresh = 130.0f;
    if (!self.isRefreshing && (containingScrollView.contentOffset.y <= -minOffsetToTriggerRefresh)) {
        self.isRefreshing = YES;
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self containingScrollViewDidEndDragging:scrollView];
}

//*****************************************************************************************************************************************

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]]) {
        // Get selected cell row index to get the selected restaurant ID
        NSArray *myIndexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [myIndexPaths objectAtIndex:0];
        
        RestaurantCell *cell = (RestaurantCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        RestaurantDetailViewController *vc = segue.destinationViewController;
        vc.restaurant = self.restaurants[indexPath.row];
        vc.restaurant.image = cell.imageView.image;
    }
}

@end
