//
//  ECAKeyValuePair.m
//  IAPValidator
//
//  Created by Erick Camacho on 6/1/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import "ECAKeyValuePair.h"

@implementation ECAKeyValuePair

- (instancetype)initWithKey:(NSObject *)key andValue:(NSObject *)value
{
  self = [super init];
  if (self) {
    self.key = key;
    self.value = value;
  }
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ -> %@", self.key, self.value];
}

@end
