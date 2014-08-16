/*
     File: SetupViewController.m
 Abstract: Displayed by either a GetLocationViewController or a TrackLocationViewController, this view controller is presented modally and communicates back to the presenting controller using a simple delegate protocol. The protocol sends setupViewController:didFinishSetupWithInfo: to its delegate with a dictionary containing a desired accuracy and either a timeout or a distance filter value. A custom UIPickerView specifies the desired accuracy. A slider is shown for setting the timeout or distance filter. This view controller can be initialized using either of two nib files: GetLocationSetupView.xib or TrackLocationSetupView.xib. These nibs have nearly identical layouts, but differ in the labels and attributes for the slider.
 
  Version: 2.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "SetupViewController.h"
#import <CoreLocation/CoreLocation.h>

NSString * const kSetupInfoKeyAccuracy = @"SetupInfoKeyAccuracy";
NSString * const kSetupInfoKeyDistanceFilter = @"SetupInfoKeyDistanceFilter";
NSString * const kSetupInfoKeyTimeout = @"SetupInfoKeyTimeout";

static NSString * const kAccuracyNameKey = @"AccuracyNameKey";
static NSString * const kAccuracyValueKey = @"AccuracyValueKey";

@implementation SetupViewController

@synthesize delegate;
@synthesize setupInfo;
@synthesize accuracyOptions;
@synthesize configureForTracking;
@synthesize accuracyPicker;
@synthesize slider;

- (void)viewDidLoad
{
    NSMutableArray *options = [NSMutableArray array];
    [options addObject:@{kAccuracyNameKey: NSLocalizedString(@"AccuracyBest", @"AccuracyBest"), kAccuracyValueKey: @(kCLLocationAccuracyBest)}];
    [options addObject:@{kAccuracyNameKey: NSLocalizedString(@"Accuracy10", @"Accuracy10"), kAccuracyValueKey: @(kCLLocationAccuracyNearestTenMeters)}];
    [options addObject:@{kAccuracyNameKey: NSLocalizedString(@"Accuracy100", @"Accuracy100"), kAccuracyValueKey: @(kCLLocationAccuracyHundredMeters)}];
    [options addObject:@{kAccuracyNameKey: NSLocalizedString(@"Accuracy1000", @"Accuracy1000"), kAccuracyValueKey: @(kCLLocationAccuracyKilometer)}];
    [options addObject:@{kAccuracyNameKey: NSLocalizedString(@"Accuracy3000", @"Accuracy3000"), kAccuracyValueKey: @(kCLLocationAccuracyThreeKilometers)}];
    self.accuracyOptions = options;
}

- (void)viewDidUnload
{
    self.accuracyPicker = nil;
    self.slider = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [accuracyPicker selectRow:2 inComponent:0 animated:NO];
    self.setupInfo = [NSMutableDictionary dictionary];
    setupInfo[kSetupInfoKeyDistanceFilter] = @100.0; 
    setupInfo[kSetupInfoKeyTimeout] = @30.0;
    setupInfo[kSetupInfoKeyAccuracy] = @(kCLLocationAccuracyHundredMeters);
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([delegate respondsToSelector:@selector(setupViewController:didFinishSetupWithInfo:)])
    {
        [delegate setupViewController:self didFinishSetupWithInfo:setupInfo];
    }
}

- (IBAction)sliderChangedValue:(id)sender
{
    if (configureForTracking)
    {
        setupInfo[kSetupInfoKeyDistanceFilter] = @(pow(10, [(UISlider *)sender value])); 
    }
    else
    {
        setupInfo[kSetupInfoKeyTimeout] = [NSNumber numberWithDouble:[(UISlider *)sender value]];
    }
}

#pragma mark Picker DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return accuracyOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *optionForRow = accuracyOptions[row];
    return optionForRow[kAccuracyNameKey];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *optionForRow = accuracyOptions[row];
    setupInfo[kSetupInfoKeyAccuracy] = optionForRow[kAccuracyValueKey];
}


@end
