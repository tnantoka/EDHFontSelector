//
//  EDHFontColorViewController.m
//  EDHFontSelector
//
//  Created by Tatsuya Tobioka on 10/4/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "EDHFontColorViewController.h"

#import "EDHFontSelector.h"
#import "EDHUtility.h"
#import "EDHFontCustomColorViewController.h"

static NSString * const reuseIdentifier = @"reuseIdentifier";

static const CGFloat kImageSize = 44.0f;

@interface EDHFontColorViewController ()

@property (nonatomic) NSArray *items;
@property (nonatomic) EDHFontColorViewControllerType type;

@end

@implementation EDHFontColorViewController

- (id)initWithType:(EDHFontColorViewControllerType)type {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.items.count - 1) {
        switch (self.type) {
            case EDHFontColorViewControllerTypeText: {
                [[EDHFontSelector sharedSelector] setTextColor:self.items[indexPath.row][@"color"]];
                break;
            }
            case EDHFontColorViewControllerTypeBackground: {
                [[EDHFontSelector sharedSelector] setBackgroundColor:self.items[indexPath.row][@"color"]];
                break;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        EDHFontCustomColorViewController *customController = [[EDHFontCustomColorViewController alloc] initWithType:self.type];
        [self.navigationController pushViewController:customController animated:YES];
    }
}

# pragma mark - Utilities

- (void)initItems {
    NSMutableArray *items = [[EDHFontSelector sharedSelector] colors].mutableCopy;
    
    UIColor *color = nil;

    switch (self.type) {
        case EDHFontColorViewControllerTypeText: {
            color = [[EDHFontSelector sharedSelector] textColor];
            break;
        }
        case EDHFontColorViewControllerTypeBackground: {
            color = [[EDHFontSelector sharedSelector] backgroundColor];
            break;
        }
    }
    
    NSDictionary *item = @{
                           @"name" : [EDHUtility localizedString:@"Custom" withScope:EDHFontSelectorPodName],
                           @"color" : color,
                           };
    [items addObject:item];

    self.items = items;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *name = self.items[indexPath.row][@"name"];
    UIColor *color = self.items[indexPath.row][@"color"];

    BOOL isSelected = NO;

    cell.textLabel.text = name;
    
    if (indexPath.row != self.items.count - 1) {
        switch (self.type) {
            case EDHFontColorViewControllerTypeText: {
                if ([color isEqual:[[EDHFontSelector sharedSelector] textColor]]) {
                    isSelected = YES;
                }
                break;
            }
            case EDHFontColorViewControllerTypeBackground: {
                if ([color isEqual:[[EDHFontSelector sharedSelector] backgroundColor]]) {
                    isSelected = YES;
                }
                break;
            }
        }
    } else {
        BOOL isCustom = YES;
        for (NSDictionary *item in [[EDHFontSelector sharedSelector] colors]) {
            if ([color isEqual:item[@"color"]]) {
                isCustom = NO;
                break;
            }
        }
        isSelected = isCustom;
    }
    
    if (isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.imageView.image = [EDHUtility imageWithColor:color size:CGSizeMake(kImageSize, kImageSize)];
}

- (void)updateAllCells {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [self configureCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

- (void)refresh {
    [self initItems];
    [self updateAllCells];
}


@end
