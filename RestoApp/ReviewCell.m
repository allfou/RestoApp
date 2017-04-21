//
//  ReviewCell.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/20/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "ReviewCell.h"
#import "YLPUser.h"

@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithReview:(YLPReview*)review {
    // User Name
    [self.userName setText:review.user.name];
    
    // User Rating
    self.userRating.allowsHalfStars = YES;
    self.userRating.accurateHalfStars = YES;
    self.userRating.value = review.rating;
    self.userRating.shouldBeginGestureRecognizerBlock = nil;
    [self.userRating setShouldBecomeFirstResponder:NO];
    [self.userRating setUserInteractionEnabled:NO];
    
    // User Review
    [self.userReview setText:review.excerpt];
}

@end
