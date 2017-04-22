//
//  ActivityViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/21/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "ActivityViewController.h"

@implementation ActivityViewController

- (BOOL)_shouldExcludeActivityType:(UIActivity *)activity {
    if ([[activity activityType] isEqualToString:@"com.apple.reminders.RemindersEditorExtension"] ||
        [[activity activityType] isEqualToString:@"com.apple.mobilenotes.SharingExtension"]) {
        return YES;
    }
    return [super _shouldExcludeActivityType:activity];
}
@end
