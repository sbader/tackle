//
//  TackMainTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface TackMainTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSDate *dueDate;

@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

- (IBAction)tenMinuteButtonPressed:(id)sender;
- (IBAction)oneHourButtonPressed:(id)sender;
- (IBAction)oneDayButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
