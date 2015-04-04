//
//  EDHFontSettingsViewController.m
//  EDHFontSelector
//
//  Created by Tatsuya Tobioka on 10/3/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "EDHFontSettingsViewController.h"

#import "EDHFontSelector.h"
#import "EDHFontNameViewController.h"
#import "EDHFontSizeViewController.h"
#import "EDHFontColorViewController.h"
#import "EDHUtility.h"

static NSString * const reuseIdentifier = @"reuseIdentifier";

static const NSInteger kAccessoryLabelTag = 1;

@interface EDHFontSettingsViewController ()

@property (nonatomic) NSArray *items;

@end

@implementation EDHFontSettingsViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = [EDHUtility localizedString:@"Font" withScope:EDHFontSelectorPodName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.presentingViewController) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneItemDidTap:)];
        self.navigationItem.rightBarButtonItem = doneItem;        
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self updateAllCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [EDHUtility localizedString:@"Settings" withScope:EDHFontSelectorPodName];
    } else if (section == 1) {
        return [EDHUtility localizedString:@"Preview" withScope:EDHFontSelectorPodName];
    } else {
        return nil;
    }
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIViewController *controller = self.items[indexPath.section][indexPath.row][@"controller"];
        if (controller) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            controller.title = cell.textLabel.text;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (indexPath.section == 1) {
    } else {
        [[EDHFontSelector sharedSelector] reset];
        [self refresh];        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

# pragma mark - Actions

- (void)doneItemDidTap:(id)sender {
    [self close];
}

# pragma mark - Utilities

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.items[indexPath.section][indexPath.row][@"title"];

    if (indexPath.section == 0) {
        UILabel *accessoryLabel = (UILabel *)[cell.contentView viewWithTag:kAccessoryLabelTag];
        
        if (!accessoryLabel) {
            accessoryLabel = [[UILabel alloc] init];
            accessoryLabel.textColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.000f]; // #8e8e93
            accessoryLabel.backgroundColor = [UIColor clearColor];
            accessoryLabel.tag = kAccessoryLabelTag;
        }

        accessoryLabel.text = self.items[indexPath.section][indexPath.row][@"value"];
        [accessoryLabel sizeToFit];
        
        CGRect frame = accessoryLabel.frame;
        CGFloat textLabelWidth = CGRectGetWidth(cell.bounds) / 2.0f;
        frame.origin.y = 12.0f;
        frame.size.width = textLabelWidth - 32.0f;
        frame.origin.x = textLabelWidth;
        accessoryLabel.frame = frame;
        accessoryLabel.textAlignment = NSTextAlignmentRight;

        [cell.contentView addSubview:accessoryLabel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = nil;
        cell.backgroundColor = [UIColor whiteColor];
    } else if (indexPath.section == 1) {
        cell.accessoryView = nil;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        cell.textLabel.textColor = [[EDHFontSelector sharedSelector] textColor];
        cell.textLabel.font = [[EDHFontSelector sharedSelector] font];
        cell.backgroundColor = [[EDHFontSelector sharedSelector] backgroundColor];
    } else {
        cell.accessoryView = nil;

        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryNone;

        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = nil;
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)close {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initItems {
    NSMutableArray *items = @[
                   @[
                       @{
                           @"title" : [EDHUtility localizedString:@"Font name" withScope:EDHFontSelectorPodName],
                           @"value" : [[EDHFontSelector sharedSelector] fontName],
                           @"controller" : [[EDHFontNameViewController alloc] init],
                           },
                       @{
                           @"title" : [EDHUtility localizedString:@"Font size" withScope:EDHFontSelectorPodName],
                           @"value" : [@([[EDHFontSelector sharedSelector] fontSize]) stringValue],
                           @"controller" : [[EDHFontSizeViewController alloc] init],
                           },
                       ].mutableCopy,
                   @[
                       @{
                           @"title" : [EDHFontSelector sharedSelector].previewText,
                           },
                       ],
                   @[
                       @{
                           @"title" : [EDHUtility localizedString:@"Reset" withScope:EDHFontSelectorPodName],
                           },
                       ],
                   ].mutableCopy;
    
    if ([EDHFontSelector sharedSelector].colorEabled) {
        NSMutableArray *section = items[0];
        [section addObjectsFromArray:@[
                                       @{
                                           @"title" : [EDHUtility localizedString:@"Text color" withScope:EDHFontSelectorPodName],
                                           @"value" : [[EDHFontSelector sharedSelector] nameForColor:[[EDHFontSelector sharedSelector] textColor]],
                                           @"controller" : [[EDHFontColorViewController alloc] initWithType:EDHFontColorViewControllerTypeText],
                                           },
                                       @{
                                           @"title" : [EDHUtility localizedString:@"Background color" withScope:EDHFontSelectorPodName],
                                           @"value" : [[EDHFontSelector sharedSelector] nameForColor:[[EDHFontSelector sharedSelector] backgroundColor]],
                                           @"controller" : [[EDHFontColorViewController alloc] initWithType:EDHFontColorViewControllerTypeBackground],
                                           },
                                       ]];
    }
    
    self.items = items;
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
