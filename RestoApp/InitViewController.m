//
//  InitViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "InitViewController.h"

@interface InitViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    
    // Init Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHomeNotification) name:@"goToHomeMessageEvent" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToHomeNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"homeSegue" sender:self];
    });
}

@end
