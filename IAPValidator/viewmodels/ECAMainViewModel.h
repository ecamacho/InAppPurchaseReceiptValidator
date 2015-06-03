//
//  ECAMainViewModel.h
//  IAPValidator
//
//  Created by Erick Camacho on 5/29/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECAConstants.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ECAMainViewModel : NSObject

@property (nonatomic, strong) NSString *password;

@property (nonatomic, assign) ECAInAppEnvironment environment;

@property (nonatomic, strong) NSString *base64Receipt;

@property (strong, nonatomic) RACCommand *executeValidation;

@property (strong, nonatomic) NSArray *responsePairs;

@end
