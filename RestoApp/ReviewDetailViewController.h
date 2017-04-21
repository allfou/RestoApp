//
//  ReviewDetailViewController.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/21/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "Review.h"

@interface ReviewDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *userRating;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UITextView *reviewText;

@property Review *review;

@end
