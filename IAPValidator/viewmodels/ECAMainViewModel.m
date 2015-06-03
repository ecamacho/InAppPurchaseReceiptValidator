//
//  ECAMainViewModel.m
//  IAPValidator
//
//  Created by Erick Camacho on 5/29/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import "ECAMainViewModel.h"

#import "NSDictionary+ECAKeyValuePairAdditions.h"
#import "ECAKeyValuePair.h"
#import "ECAReceiptValidator.h"

@interface ECAMainViewModel ()

@property (nonatomic, strong) ECAReceiptValidator *validator;

@end

@implementation ECAMainViewModel

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize
{
  self.environment = ECAInAppEnvironmentSandbox;
  self.validator = [[ECAReceiptValidator alloc] init];
  RACSignal *validReceiptSignal = [[RACObserve(self, base64Receipt)
                                    map:^id(NSString *text) {
                                      return @(text.length > 100);
                                    }] distinctUntilChanged];
    
  self.executeValidation = [[RACCommand alloc] initWithEnabled:validReceiptSignal
                                                   signalBlock:^RACSignal *(id input) {
                                                     return [self executeValidationSignal];
                                                   }];
}



- (RACSignal *)executeValidationSignal
{
  return [[self.validator validateReceipt:self.base64Receipt password:self.password inEnvironment:self.environment]
          doNext:^(NSDictionary *jsonResponse) {
    self.responsePairs = [jsonResponse ECAToKeyValuePairArray];
  }];
}



@end
