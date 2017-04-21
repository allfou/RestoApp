//
//  AppDelegate.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//
//  Documentation - Yelp API iOS - https://github.com/Yelp/yelp-ios

#import "AppDelegate.h"
#import "YLPClient.h"

@interface AppDelegate ()

@property (strong, nonatomic) YLPClient *client;

@end

@implementation AppDelegate

+ (YLPClient *)sharedYelpClient {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.client;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Load User and App Configurations
    NSURL *configFile = [[NSBundle mainBundle] URLForResource:@"Config" withExtension:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfURL:configFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:config];
    NSString *appId = [[NSUserDefaults standardUserDefaults] valueForKey:@"yelp_client_id"];
    NSString *secret = [[NSUserDefaults standardUserDefaults] valueForKey:@"yelp_client_secret"];
    
    // Create Yelp Client
    [YLPClient authorizeWithAppId:appId secret:secret completionHandler:^(YLPClient *client, NSError *error) {
        self.client = client;
        if (!client) {
            NSLog(@"Authentication failed: %@", error);
        } else {
            // Yelp client is ready, go to home page
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goToHomeMessageEvent" object:nil];
        }
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
