//
//  ReviewDetailViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/21/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ReviewDetailViewController ()

@end

@implementation ReviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set User Avatar
    [self.userAvatar setImageWithURL:self.review.review.user.imageURL];
    
    // Set User name
    [self.userName setText:self.review.review.user.name];
    [self.userName setText:self.review.review.user.name];
    
    // Set Review rating
    self.userRating.allowsHalfStars = YES;
    self.userRating.accurateHalfStars = YES;
    self.userRating.value = self.review.review.rating;
    self.userRating.shouldBeginGestureRecognizerBlock = nil;
    [self.userRating setShouldBecomeFirstResponder:NO];
    [self.userRating setUserInteractionEnabled:NO];
    
    // Set Review Text
    [self.reviewText setText:self.review.review.excerpt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
