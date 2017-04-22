//
//  ActivityViewController.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/21/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActivityViewController (Private)

- (BOOL)_shouldExcludeActivityType:(UIActivity*)activity;

@end

@interface ActivityViewController : UIActivityViewController

@end
