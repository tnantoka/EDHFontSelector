//
//  EDHFontSelector.m
//  EDHFontSelector
//
//  Created by Tatsuya Tobioka on 10/3/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "EDHFontSelector.h"

#import <objc/runtime.h>

static NSString * const kFontNameKey = @"kFontNameKey";
static NSString * const kFontSizeKey = @"kFontSizeKey";
static NSString * const kTextColorKey = @"kTextColorKey";
static NSString * const kBackgroundColorKey = @"kBackgroundColorKey";

@implementation EDHFontSelector

static EDHFontSelector *sharedInstance = nil;

+ (instancetype)sharedSelector {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        [self registarDefaults];
        
        self.previewText = NSLocalizedString(@"ABCDEFGHIJKLM NOPQRSTUVWXYZ abcdefghijklm nopqrstuvwxyz 1234567890", nil);
    }
    return self;
}

- (UINavigationController *)settingsNavigationController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self settingsViewController]];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    return navController;
}

- (EDHFontSettingsViewController *)settingsViewController {
    return [[EDHFontSettingsViewController alloc] init];
}

- (void)applyToTextView:(UITextView *)textView {
    textView.textColor = [self textColor];
    textView.backgroundColor = [self backgroundColor];
    textView.font = [self font];
}

- (NSString *)identifier {
    return @"com.bornneet.EDHFontSelector";
}

- (NSString *)keyWithType:(NSString *)type {
    return [NSString stringWithFormat:@"%@.%@", [self identifier], type];
}

- (UIFont *)font {
    return [UIFont fontWithName:[self fontName] size:[self fontSize]];
}

- (NSString *)fontName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self keyWithType:kFontNameKey]];
}

- (CGFloat)fontSize {
    return [[NSUserDefaults standardUserDefaults] floatForKey:[self keyWithType:kFontSizeKey]];
}

- (UIColor *)textColor {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:[self keyWithType:kTextColorKey]]];
}

- (UIColor *)backgroundColor {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:[self keyWithType:kBackgroundColorKey]]];
}

- (void)setFontName:(NSString *)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:[self keyWithType:kFontNameKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFontSize:(CGFloat)size {
    [[NSUserDefaults standardUserDefaults] setFloat:size forKey:[self keyWithType:kFontSizeKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTextColor:(UIColor *)color {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:color] forKey:[self keyWithType:kTextColorKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBackgroundColor:(UIColor *)color {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:color] forKey:[self keyWithType:kBackgroundColorKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reset {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self keyWithType:kFontNameKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self keyWithType:kFontSizeKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self keyWithType:kTextColorKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self keyWithType:kBackgroundColorKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)nameForColor:(UIColor *)color {
    for (NSDictionary *c in [self colors]) {
        if ([color isEqual:c[@"color"]]) {
            return c[@"name"];
        }
    }
    return @"";
}

- (NSArray *)colors {

    NSMutableArray *colors = @[
             @{
                 @"name" : NSLocalizedString(@"Black", nil),
                 @"color" : [UIColor blackColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Dark gray", nil),
                 @"color" : [UIColor darkGrayColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Light gray", nil),
                 @"color" : [UIColor lightGrayColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"White", nil),
                 @"color" : [UIColor whiteColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Gray", nil),
                 @"color" : [UIColor grayColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Red", nil),
                 @"color" : [UIColor redColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Green", nil),
                 @"color" : [UIColor greenColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Blue", nil),
                 @"color" : [UIColor blueColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Cyan", nil),
                 @"color" : [UIColor cyanColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Yellow", nil),
                 @"color" : [UIColor yellowColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Magenta", nil),
                 @"color" : [UIColor magentaColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"OrangeColor", nil),
                 @"color" : [UIColor orangeColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"PurpleColor", nil),
                 @"color" : [UIColor purpleColor],
                 },
             @{
                 @"name" : NSLocalizedString(@"Brown", nil),
                 @"color" : [UIColor brownColor],
                 },
             ].mutableCopy;
    
//    NSMutableArray *colors = @[].mutableCopy;
//    unsigned int count;
//    Method *methods;
//    Class targetClass = [UIColor class];
//
//    methods = class_copyMethodList(object_getClass(targetClass), &count);
//    for (int i = 0; i < count; i++) {
//        NSString *name = NSStringFromSelector(method_getName(methods[i]));
//        NSRange range = [name rangeOfString:@"^[^_].+?Color$" options:NSRegularExpressionSearch];
//        if (range.location != NSNotFound) {
//            SEL selector = NSSelectorFromString(name);
//            if ([UIColor respondsToSelector:selector]) {
//                UIColor *color =  [UIColor performSelector:selector];
//                if (color) {
//                    if ([color isEqual:[UIColor clearColor]]) {
//                        continue;
//                    }
//                    for (NSDictionary *c in colors) {
//                        if ([color isEqual:c[@"color"]]) {
//                            continue;
//                        }
//                    }
//                    
//                    [colors addObject:@{
//                                        //@"name" : name,
//                                        @"name" : [NSString stringWithFormat:@"%@ (%@)", name, [color description]],
//                                        @"color" : color,
//                                        }];
//                }
//            }
//        }
//    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [colors sortUsingDescriptors:@[descriptor]];
    
    return colors;
}

# pragma mark - Utilities

- (void)registarDefaults {    
    NSMutableDictionary *defaults = @{}.mutableCopy;
    [defaults setObject:@"HelveticaNeue" forKey:[self keyWithType:kFontNameKey]];
    [defaults setObject:@(14.0f) forKey:[self keyWithType:kFontSizeKey]];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]] forKey:[self keyWithType:kTextColorKey]];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[UIColor whiteColor]] forKey:[self keyWithType:kBackgroundColorKey]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
