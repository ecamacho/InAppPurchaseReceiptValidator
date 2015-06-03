//
//  ECAReceiptValidator.h
//  IAPValidator
//
//  Created by Erick Camacho on 5/29/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECAConstants.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ECAReceiptValidator : NSObject

- (RACSignal *)validateReceipt:(NSString *)receipt password:(NSString *)password inEnvironment:(ECAInAppEnvironment)env;

@end
