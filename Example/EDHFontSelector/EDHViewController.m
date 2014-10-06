//
//  EDHViewController.m
//  EDHFontSelector
//
//  Created by tnantoka on 10/05/2014.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "EDHViewController.h"

#import "EDHFontSelector.h"

@interface EDHViewController ()

@property (nonatomic) UITextView *textView;

@end

@implementation EDHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:self action:@selector(settingsItemDidTap:)];
    self.navigationItem.leftBarButtonItem = settingsItem;
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.text = @"EDHFontSelector";
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[EDHFontSelector sharedSelector] applyToTextView:self.textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Actions

- (void)settingsItemDidTap:(id)sender {
    [self presentViewController:[[EDHFontSelector sharedSelector] settingsNavigationController] animated:YES completion:nil];
}

@end
