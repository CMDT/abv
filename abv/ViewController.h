//
//  ViewController.h
//  abv
//
//  Created by Jon Howell on 10/02/2017.
//  Copyright © 2017 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField * alcTF;
@property (strong, nonatomic) IBOutlet UITextField * mixTF;
@property (strong, nonatomic) IBOutlet UITextField * abvTF;
@property (strong, nonatomic) IBOutlet UITextField * unitsTF;

@property (strong, nonatomic) IBOutlet UITextField * bottleSzTF;

@property (strong, nonatomic) IBOutlet UILabel * portionsLBL;

@property (strong, nonatomic) IBOutlet UILabel * alcWtLBL;
@property (strong, nonatomic) IBOutlet UILabel * mixWtLBL;
@property (strong, nonatomic) IBOutlet UILabel * totWtLBL;

@property (strong, nonatomic) IBOutlet UILabel * alcVolLBL;
@property (strong, nonatomic) IBOutlet UILabel * mixVolLBL;
@property (strong, nonatomic) IBOutlet UILabel * totVolLBL;

@property (weak, nonatomic) IBOutlet UIButton *calculate;
- (IBAction)alcChanged:(id)sender;
- (IBAction)mixChanged:(id)sender;
- (IBAction)abvChanged:(id)sender;
- (IBAction)unitsChanged:(id)sender;
- (IBAction)bottleChanged:(id)sender;
@end
