//
//  ECAReceiptValidator.m
//  IAPValidator
//
//  Created by Erick Camacho on 5/29/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import "ECAReceiptValidator.h"

@implementation ECAReceiptValidator

- (RACSignal *)validateReceipt:(NSString *)receipt password:(NSString *)password inEnvironment:(ECAInAppEnvironment)env
{
  RACReplaySubject *subject = [RACReplaySubject subject];
  NSMutableDictionary *params = [@{@"receipt-data": receipt} mutableCopy];
  if (password) {
    params[@"password"] = password;
  }
  NSError *error;
  NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
  if (error == nil) {
    NSURL *url;
    if (env == ECAInAppEnvironmentSandbox) {
      url = [NSURL URLWithString:SANDBOX_URL];
    } else {
      url = [NSURL URLWithString:PRODUCTION_URL];
    }
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:requestData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        [subject sendError:error];
        [subject sendCompleted];
      } else {
        NSError *jsonErr;
        id result =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
        [subject sendNext:result];
        [subject sendCompleted];
      }
    }];
    [task resume];
  } else {
    [subject sendError:error];
    [subject sendCompleted];
  }
  
  
  return subject;
}

@end
