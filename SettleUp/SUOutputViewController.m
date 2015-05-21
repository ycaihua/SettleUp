//
//  SUOutputViewController.m
//  SettleUp
//
//  Created by Connor Neville on 4/10/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import "SUOutputViewController.h"
#import "NSArray+RandomSelection.h"
#import "CNLabel.h"

@interface SUOutputViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SUOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* rules = [self getListOfRules];
    NSMutableArray* chosenRules = [self getListOfChosenRulesFromList:rules];
    NSMutableArray* labels = [self getListOfLabelsFromChosenRules:chosenRules];
    [self placeLabelsOnView:labels];
}

- (NSMutableArray*) getListOfRules {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Rules" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString* trimmedContent = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSArray* ruleBlocksByType = [trimmedContent componentsSeparatedByString:@"&"];
    NSMutableArray* arrayOfArrays = [[NSMutableArray alloc] init];
    for(NSString* ruleType in ruleBlocksByType) {
        NSMutableArray* rulesForType = [[ruleType componentsSeparatedByString:@"#"] mutableCopy];
        [rulesForType removeObject:@""];
        [arrayOfArrays addObject:rulesForType];
    }
    return arrayOfArrays;
}

- (NSMutableArray*) getListOfChosenRulesFromList: (NSMutableArray*) rules {
    NSMutableArray* chosenRules = [[NSMutableArray alloc] init];
    for(int i = 0; i < 3; i++) {
        int numRulesToSelect = [self.counterValues[i] intValue];
        NSArray* rulesOfCurrentType = rules[i];
        NSArray* chosenRulesOfCurrentType = [rulesOfCurrentType randomSelectionWithCount:numRulesToSelect];
        [chosenRules addObjectsFromArray:chosenRulesOfCurrentType];
    }
    return chosenRules;
}

- (NSMutableArray*) getListOfLabelsFromChosenRules: (NSMutableArray*) chosenRules {
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    for(NSString* rule in chosenRules) {
        CNLabel* currentLabel = [[CNLabel alloc] initWithText:rule];
        currentLabel.font = [UIFont fontWithName:@"Heiti SC" size:18.0f];
        currentLabel.textColor = [UIColor blackColor];
        currentLabel.tag = -1;
        [labels addObject:currentLabel];
    }
    return labels;
}

- (void) placeLabelsOnView: (NSMutableArray*) labels {
    for(int i = 0; i < labels.count; i++) {
        CNLabel* currentLabel = labels[i];
        [currentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:currentLabel];
        if(i == 0) {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.titleLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:10.0f]];
        }
        else {
            UILabel* previousLabel = labels[i-1];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:previousLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:10.0f]];
        }
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeftMargin
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRightMargin
                                                             multiplier:1.0f
                                                               constant:0.0f]];
    }
}



- (IBAction)tryAgainButtonPressed:(id)sender {
    for(UIView* view in [self.view subviews]) {
        if(view.tag == -1) {
            [view removeFromSuperview];
        }
    }
    [self viewDidLoad];
}

- (IBAction)backHomeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ReturnHomeSegue" sender:self];
}

@end
