//
//  DetailViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "DetailViewController.h"
//#import "LocationService.h"
#import "YelpService.h"
#import "YLPReview.h"
#import "YLPBusiness.h"
#import "YLPBusinessReviews.h"
#import "YLPClient+Search.h"
#import "YLPClient+Reviews.h"
#import "YLPClient+Business.h"
#import "YLPResponsePrivate.h"
#import "AppDelegate.h"
#import "ReviewCell.h"

@interface DetailViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray<YLPReview *> *reviews;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Init Table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewRestaurantCell" bundle:nil] forCellReuseIdentifier:@"reviewCell"];
    
    // Init Data
    self.reviews = [NSArray<YLPReview *> new];
    
    // Init Restaurant details
    [self.name setText:self.restaurant.business.name];
    [self.totalReviews setText:[NSString stringWithFormat:@"%lu Reviews", (unsigned long)[self.restaurant.business reviewCount]]];
    if (self.restaurant.business.isClosed) {
        [self.hours setText:@"Closed"];
        [self.hours setBackgroundColor:[UIColor redColor]];
    } else {
        [self.hours setText:@"Open"];
        [self.hours setTintColor:[UIColor greenColor]];
    }
    self.rating.allowsHalfStars = YES;
    self.rating.accurateHalfStars = YES;
    self.rating.value = self.restaurant.business.rating;
    self.rating.shouldBeginGestureRecognizerBlock = nil;
    [self.rating setShouldBecomeFirstResponder:NO];
    [self.rating setUserInteractionEnabled:NO];
    
    // Init Restaurant Reviews
    [[AppDelegate sharedYelpClient] reviewsForBusinessWithId:self.restaurant.business.identifier completionHandler:^
    (YLPBusinessReviews *reviews, NSError *error) {
      NSLog(@"%@", reviews);
        self.reviews = reviews.reviews;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource

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
    
    return cell;
}

@end
