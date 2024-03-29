//
//  PaintCodeStyleKit.h
//  Tackle
//
//  Created by Scott Bader on 2/3/16.
//  Copyright (c) 2016 Melody Road, LLC. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PaintCodeStyleKit : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alarmClockIconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* letterTIconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* addIconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* arrowTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* clockOldTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* clockOldTwoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* stopWatchTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* calendarIconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* clockTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* creditsTIconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconOneTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconTwoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconThreeTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconFourTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconFiveTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconSixTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconSevenTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconEightTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconNinePlusTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* alertIconMasterTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* calanderColoredTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* hourglassColoredTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* stopwatchColoredTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* checkmarkTargets;

// Drawing Methods
+ (void)drawClockComponents;
+ (void)drawCanvas1;

// Generated Images
+ (UIImage*)imageOfAlarmClockIcon;
+ (UIImage*)imageOfLetterTIcon;
+ (UIImage*)imageOfAddIcon;
+ (UIImage*)imageOfArrow;
+ (UIImage*)imageOfClockOld;
+ (UIImage*)imageOfClockOldTwo;
+ (UIImage*)imageOfStopWatch;
+ (UIImage*)imageOfCalendarIcon;
+ (UIImage*)imageOfHourglassIconWithFrame: (CGRect)frame;
+ (UIImage*)imageOfClock;
+ (UIImage*)imageOfCreditsTIcon;
+ (UIImage*)imageOfAlertIconOne;
+ (UIImage*)imageOfAlertIconTwo;
+ (UIImage*)imageOfAlertIconThree;
+ (UIImage*)imageOfAlertIconFour;
+ (UIImage*)imageOfAlertIconFive;
+ (UIImage*)imageOfAlertIconSix;
+ (UIImage*)imageOfAlertIconSeven;
+ (UIImage*)imageOfAlertIconEight;
+ (UIImage*)imageOfAlertIconNinePlus;
+ (UIImage*)imageOfAlertIconMaster;
+ (UIImage*)imageOfCalanderColored;
+ (UIImage*)imageOfHourglassColored;
+ (UIImage*)imageOfStopwatchColored;
+ (UIImage*)imageOfCheckmark;

@end
