//
//  ECAConstants.h
//  IAPValidator
//
//  Created by Erick Camacho on 6/2/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ECAInAppEnvironment) {
  ECAInAppEnvironmentSandbox,
  ECAInAppEnvironmentProduction
};

extern NSString * const SANDBOX_URL;
extern NSString * const PRODUCTION_URL;

@interface ECAConstants : NSObject

@end
