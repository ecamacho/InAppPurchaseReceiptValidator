//
//  NSDictionary+ECAKeyValuePairAdditions.h
//  IAPValidator
//
//  Created by Erick Camacho on 6/1/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECAKeyValuePair.h"

@interface NSDictionary (ECAKeyValuePairAdditions)

- (NSArray *)ECAToKeyValuePairArray;

@end
