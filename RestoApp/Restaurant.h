//
//  Restaurant.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLPBusiness.h"

@interface Restaurant : NSObject

@property (nonatomic, strong) YLPBusiness *business;
@property (nonatomic, strong) NSMutableArray *reviews;

@end
