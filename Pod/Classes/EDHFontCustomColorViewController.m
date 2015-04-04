//
//  EDHFontCustomColorViewController.m
//  EDHFontSelector
//
//  Created by Tatsuya Tobioka on 3/29/15.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "EDHFontCustomColorViewController.h"

#import "EDHFontSelector.h"

static NSString * const reuseIdentifier = @"reuseIdentifier";

static const NSInteger kRedIndex = 0;
static const NSInteger kGreenIndex = 1;
static const NSInteger kBlueIndex = 2;

@interface EDHFontCustomColorViewController ()

@property (nonatomic) NSArray *items;
@property (nonatomic) EDHFontColorViewControllerType type;
@property (nonatomic, copy) UIColor *color;

@end

@implementation EDHFontCustomColorViewController

- (id)initWithType:(EDHFontColorViewControllerType)type {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [self initItems];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return self.items.count;
            break;
        }
        case 1: {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

# pragma mark - Utilities

- (void)initItems {
    
    switch (self.type) {
        case EDHFontColorViewControllerTypeText: {
            self.color = [[EDHFontSelector sharedSelector] textColor];
            break;
        }
        case EDHFontColorViewControllerTypeBackground: {
            self.color = [[EDHFontSelector sharedSelector] backgroundColor];
            break;
        }
    }

    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    [self.color getRed:&red green:&green blue:&blue alpha:nil];
    
    NSMutableArray *items = @[].mutableCopy;
    
    NSArray *titles = @[@"R", @"G", @"B"];
    
    NSInteger i = 0;
    for (NSString *title in titles) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
        slider.minimumValue = 0.0f;
        slider.maximumValue = 255.0f;
        slider.tag = i;
        
        [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];

        CGFloat value = 0.0f;
        switch (i) {
            case kRedIndex:
                value = red;
                break;
            case kGreenIndex:
                value = green;
                break;
            case kBlueIndex:
                value = blue;
                break;
        }
        slider.value = value * 255.0f;
        
        [slider sizeToFit];
        
        CGRect frame = slider.frame;
        frame.size.width = 200.0f;
        slider.frame = frame;
        
        [slider addTarget:self action:@selector(sliderDidTap:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *item = @{
                           @"title" : title,
                           @"slider" : slider,
                           };
        [items addObject:item];
        i++;
    }
    
    self.items = items;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            NSString *title = self.items[indexPath.row][@"title"];
            UISlider *slider = self.items[indexPath.row][@"slider"];
            
            cell.textLabel.text = title;
            cell.accessoryView = slider;

            cell.backgroundColor = [UIColor whiteColor];
            
            [self sliderDidChange:slider];

            break;
        }
        case 1: {
            cell.backgroundColor = self.color;
            
            break;
        }
    }
}

- (void)updateAllCells {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [self configureCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

# pragma mark - Actions

- (void)sliderDidChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    slider.value = roundf(slider.value);

    NSInteger i = slider.tag;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    NSMutableString *title = self.items[i][@"title"];
    cell.textLabel.text = [title stringByAppendingFormat:@": %d", (int)slider.value];
}

- (void)sliderDidTap:(id)sender {
    CGFloat r = ((UISlider *)self.items[kRedIndex][@"slider"]).value;
    CGFloat g = ((UISlider *)self.items[kGreenIndex][@"slider"]).value;
    CGFloat b = ((UISlider *)self.items[kBlueIndex][@"slider"]).value;
    self.color = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    switch (self.type) {
        case EDHFontColorViewControllerTypeText: {
            [[EDHFontSelector sharedSelector] setTextColor:self.color];
            break;
        }
        case EDHFontColorViewControllerTypeBackground: {
            [[EDHFontSelector sharedSelector] setBackgroundColor:self.color];
            break;
        }
    }
}

@end
