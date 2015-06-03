//
//  ECAMainViewController.m
//  IAPValidator
//
//  Created by Erick Camacho on 5/28/15.
//  Copyright (c) 2015 ecamacho. All rights reserved.
//

#import "ECAMainViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ECAMainViewModel.h"
#import "ECAKeyValuePair.h"
#import "ECAConstants.h"

@interface ECAMainViewController () <NSOutlineViewDataSource>

@property (nonatomic, strong) ECAMainViewModel *viewModel;
@property (nonatomic, weak) IBOutlet NSSplitView *splitView;
@property (nonatomic, weak) IBOutlet NSTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet NSMatrix *optionsMatrix;
@property (nonatomic, weak) IBOutlet NSButtonCell *sandboxButton;
@property (nonatomic, weak) IBOutlet NSButtonCell *productionButton;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextView *receiptTextView;
@property (nonatomic, weak) IBOutlet NSButton *validateButton;
@property (nonatomic, weak) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;


@end

@implementation ECAMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.viewModel = [[ECAMainViewModel alloc] init];
  self.outlineView.dataSource = self;
  [self bindViewModel];
}

- (void)viewWillAppear
{
  [super viewWillAppear];
  [self.splitView setPosition:250 ofDividerAtIndex:0];
}

- (void)bindViewModel
{
  RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
  RAC(self.viewModel, base64Receipt) = self.receiptTextView.rac_textSignal;
  RAC(self.viewModel, environment) = [[self.sandboxButton rac_signalForSelector:@selector(setState:)] map:^id (RACTuple *value) {
    return @([value.first boolValue] ? ECAInAppEnvironmentSandbox : ECAInAppEnvironmentProduction);
  }];
  self.validateButton.rac_command = self.viewModel.executeValidation;
  [self.viewModel.executeValidation.executing subscribeNext:^(id x) {
    BOOL isExecuting = [x boolValue];
    if (isExecuting) {
      self.progressIndicator.hidden = NO;
      [self.progressIndicator startAnimation:nil];
    } else {
      [self.progressIndicator stopAnimation:nil];
      self.progressIndicator.hidden = YES;
    }
    
  }];
  @weakify(self);
  [RACObserve(self.viewModel, responsePairs)  subscribeNext:^(id x) {
    @strongify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.viewModel.responsePairs) {
        [self.outlineView reloadData];
      }
    });
  }];
}


#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
  if (self.viewModel.responsePairs) {
    if (!item) {
      return [self.viewModel.responsePairs count];;
    } else {
      if ([item isKindOfClass:[ECAKeyValuePair class]]) {
        NSObject *elem = [item value];
        if ([elem isKindOfClass:[NSArray class]]) {
          return [(NSArray *)elem count];
        }
      }
      
    }
  }
  return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
  if (item) {
    if ([item isKindOfClass:[NSArray class]]) {
      return item[index];
    } else if ([item isKindOfClass:[ECAKeyValuePair class]]) {
      NSObject *elem = [item value];
      if ([elem isKindOfClass:[NSArray class]]) {
        return [(NSArray *)elem objectAtIndex:index];
      }
    }
  } else {
    return self.viewModel.responsePairs[index];
  }
  return @"";
}



- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
  if ([item isKindOfClass:[ECAKeyValuePair class]]) {
    return [[item value] isKindOfClass:[NSArray class]];
  }
  return NO;
}



- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
  if ([tableColumn.identifier isEqualToString:@"title"]) {
    if ([item isKindOfClass:[ECAKeyValuePair class]]) {
      return [item key];
    }
  } else {
    if ([item isKindOfClass:[ECAKeyValuePair class]]) {
      if ([[item value] isKindOfClass:[NSArray class]]) {
        return @"";
      } else {
        return [item value];
      }
    }
  }
  return [item description];
}

@end
