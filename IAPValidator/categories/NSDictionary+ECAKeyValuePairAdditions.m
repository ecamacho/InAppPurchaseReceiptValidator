//
//  NSDictionary+ECAKeyValuePairAdditions.m
//  IAPValidator
//
//  Created by Erick Camacho on 6/1/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import "NSDictionary+ECAKeyValuePairAdditions.h"

@implementation NSDictionary (ECAKeyValuePairAdditions)

- (NSArray *)ECAToKeyValuePairArray
{
  return [self mapDictionaryToArray:self];
}

- (NSArray *)mapDictionaryToArray:(NSDictionary *)dic
{
  NSMutableArray *pairs = [NSMutableArray array];
  for (NSObject *key in dic.allKeys) {
    NSObject *val = dic[key];
    if ([val isKindOfClass:[NSDictionary class]]) {
      NSArray *array = [self mapDictionaryToArray:(NSDictionary *)val];
      [pairs addObject:[[ECAKeyValuePair alloc] initWithKey:key andValue:array]];
    }
    else if ([val isKindOfClass:[NSArray class]]) {
      NSMutableArray *array = [NSMutableArray array];
      NSArray *valArray = (NSArray *)val;
      for (int i = 0; i < [valArray count]; i++) {
        NSObject *elem = valArray[i];
        if ([elem isKindOfClass:[NSDictionary class]]) {
          [array addObject:[[ECAKeyValuePair alloc] initWithKey:[NSString stringWithFormat:@"%d", i]
                                                       andValue:[self mapDictionaryToArray:(NSDictionary *)elem]]];
        } else {
          [array addObject:elem];
        }
      }
      [pairs addObject:[[ECAKeyValuePair alloc] initWithKey:key andValue:array]];
    } else {
      [pairs addObject:[[ECAKeyValuePair alloc] initWithKey:key andValue:dic[key]]];
    }
    
  }
  return pairs;
}

@end
