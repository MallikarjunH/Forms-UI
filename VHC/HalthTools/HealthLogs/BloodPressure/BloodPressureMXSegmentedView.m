//
//  BloodPressureMXSegmentedView.m
//  VidalHealth
//
//  Created by mallikarjun on 17/07/19.
//  Copyright © 2019 Clean Bill of Health Private Limited. All rights reserved.
//

#import "BloodPressureMXSegmentedView.h"

@interface BloodPressureMXSegmentedView ()
{
    NSArray *lPages;
}

@end

@implementation BloodPressureMXSegmentedView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!lPages) lPages = [[NSArray alloc]init];
    self.segmentedPager.segmentedControl.type = HMSegmentedControlTypeText;
    self.segmentedPager.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 2.5;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor colorWithHexString:@"#6689BD"];
    [self.segmentedPager.segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title];
        if (selected) {
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
            [attString addAttribute:NSFontAttributeName value:LatoRegularFont(15) range:NSMakeRange(0,title.length)];
        }
        else {
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
            [attString addAttribute:NSFontAttributeName value:LatoRegularFont(15) range:NSMakeRange(0,title.length)];
        }
        return attString;
    }];
    [self setupPages:NO];
    
}


- (void)setupPages:(BOOL)reloadViews
{
    NSMutableArray *pages = [[NSMutableArray alloc]init];
    [pages addObject:@{@"view":self.BloodPressureLogs_Obj.view, @"title":@"LOGS"}];
    [pages addObject:@{@"view":self.BloodPressureReports_Obj.view, @"title":@"REPORTS"}];
   
    lPages = pages;
    [self.segmentedPager reloadData];
}
- (BloodPressureLogs *)BloodPressureLogs_Obj
{
    if (!_BloodPressureLogs_Obj) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"HealthTools" bundle:nil];
        _BloodPressureLogs_Obj = [board instantiateViewControllerWithIdentifier:@"BloodPressureLogsId"];
        
    }
    return _BloodPressureLogs_Obj;
}

- (BloodPressureReports *)BloodPressureReports_Obj
{
    if (!_BloodPressureReports_Obj) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"HealthTools" bundle:nil];
        _BloodPressureReports_Obj = [board instantiateViewControllerWithIdentifier:@"BloodPressureReportsId"];
        
    }
    return _BloodPressureReports_Obj;
}


- (void)segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithIndex:(NSInteger)index{
    [self.view endEditing:true];
}

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return [lPages count];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    return lPages[index][@"view"];
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return lPages[index][@"title"];
}

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager*)segmentedPager {
    return 50;
}

@end
