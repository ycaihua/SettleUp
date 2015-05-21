//
//  SUInputViewController.m
//  SettleUp
//
//  Created by Connor Neville on 4/10/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import "SUInputViewController.h"
#import "SUOutputViewController.h"
#import "CNLabel.h"

@interface SUInputViewController ()

@property (strong, nonatomic) IBOutletCollection(CNLabel) NSArray *counterLabels;

@end

@implementation SUInputViewController

const int MIN_SUM = 1;
const int MAX_SUM = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)decrementArrowPressed:(id)sender {
    UIButton* senderAsButton = sender;
    NSInteger senderTag = senderAsButton.tag;
    CNLabel* targetLabel = self.counterLabels[senderTag];
    if([self calculateCurrentSum] > MIN_SUM) {
        [targetLabel decrementTextAndRevertAfter:FALSE];
    }
}

- (IBAction)incrementArrowPressed:(id)sender {
    UIButton* senderAsButton = sender;
    NSInteger senderTag = senderAsButton.tag;
    CNLabel* targetLabel = self.counterLabels[senderTag];
    if([self calculateCurrentSum] < MAX_SUM) {
        [targetLabel incrementTextAndRevertAfter:FALSE];
    }
}

- (IBAction)goButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"DisplayOutputSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DisplayOutputSegue"]) {
        SUOutputViewController *vc = [segue destinationViewController];
        NSMutableArray* counterValues = [self getCounterValues];
        [vc setCounterValues:counterValues];
    }
}

- (NSMutableArray*) getCounterValues {
    NSMutableArray* counterValues = [[NSMutableArray alloc] init];
    for(CNLabel* label in self.counterLabels) {
        [counterValues addObject:[NSNumber numberWithInt:[label.text intValue]]];
    }
    return counterValues;
}

- (int) calculateCurrentSum {
    int sum = 0;
    for(CNLabel* label in self.counterLabels) {
        sum += [label.text intValue];
    }
    return sum;
}

@end
