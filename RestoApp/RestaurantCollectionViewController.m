//
//  RestaurantCollectionViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "RestaurantCollectionViewController.h"
#import "DetailViewController.h"
#import "RestaurantCell.h"
#import "YelpService.h"
#import "YLPClient.h"
#import "YLPSearch.h"
#import "Restaurant.h"
#import "Theme.h"
#import "LocationService.h"


@interface RestaurantCollectionViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) NSArray *restaurants;
@property BOOL currentListViewMode;
@property BOOL isRefreshing;
@property (nonatomic, strong) YelpService *yelpService;
//@property (nonatomic, strong) LocationService *locationService;

@end

@implementation RestaurantCollectionViewController

static NSString * const listCellID = @"listCell";
static NSString * const detailCellID = @"detailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRestaurantList:) name:@"refreshRestaurantListMessageEvent" object:nil];
    
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

    // Init Yelp Service
    self.yelpService = [[YelpService sharedManager]init];
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

- (void)initData {
    [[YelpService sharedManager]getNearByRestaurantsForCurrentLocation];
}

- (void)refreshRestaurantList:(NSNotification*)notification {
    
    self.restaurants = [notification object];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark <UICollectionViewDataSource>

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

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


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
    
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        // Get selected cell row index to get the selected restaurant ID
        NSArray *myIndexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [myIndexPaths objectAtIndex:0];
        DetailViewController *vc = segue.destinationViewController;
        vc.restaurantId = [[self.restaurants[indexPath.row] business] identifier];        
    }
}

@end
