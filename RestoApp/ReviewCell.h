//
//  ReviewCell.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/20/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "YLPReview.h"
@interface ReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *userRating;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UITextView *userReview;

- (void)updateCellWithReview:(YLPReview*)review;

@end
