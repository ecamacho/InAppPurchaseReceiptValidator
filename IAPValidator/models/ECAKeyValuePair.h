//
//  ECAKeyValuePair.h
//  IAPValidator
//
//  Created by Erick Camacho on 6/1/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECAKeyValuePair : NSObject

@property (nonatomic, strong) NSObject *key;

@property (nonatomic, strong) NSObject *value;

- (instancetype)initWithKey:(NSObject *)key andValue:(NSObject *)value;

@end
