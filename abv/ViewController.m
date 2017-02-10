//
//  ViewController.m
//  abv
//
//  Created by Jon Howell on 10/02/2017.
//  Copyright © 2017 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    BOOL keyboardAnim;
    float keyboardAnimSpeed;
    float keyboardAnimDelay;
}

@synthesize
    abvTF,
    alcTF,
    alcWtLBL,
    alcVolLBL,
    portionsLBL,
    mixTF,
    mixWtLBL,
    mixVolLBL,
    unitsTF,
    bottleSzTF,
    totWtLBL,
    totVolLBL,
    calculate,
    informationText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keyboardAnim      = YES;
    keyboardAnimSpeed = 1;
    keyboardAnimDelay = 1;
    
    alcTF.delegate      = self;
    mixTF.delegate      = self;
    unitsTF.delegate    = self;
    bottleSzTF.delegate = self;
    abvTF.delegate      = self;
    
    //add text to information screen
    informationText.text=@"This calculator will give you the volume and weight of beverage for a fixed number of UK alcohol units, taking into account the specific gravity (S.G.) of the alcohol mix (ethanol/other alcohols), and the base carrier (usually water).\n\nYou may need to adjust the S.G.'s of both depending upon the sugar and solids content of the components, as the weights and values will change dependent upon the alteration of the S.G. of the substances involved.\n\nA Unit of Alcohol is 10ml of pure alcohol or 7.87g of pure alcohol.\n\nFrom the beverage product information, look for the ABV value in %, and enter it in the ABV field.\n\nEnter the number of Alcohol Units you wish to calculate the volume and weight data.\n\nPlease NOTE:\n\nThis calculator is NOT to be used for clinical or legal purposes.\n\nThis calculator is for Educational and learning purposes only, and any actual consumption of alcohol is purely the responsibility of the consumer and NOT  in any way this application.\n\nThis App developed by Jonathan Howell, Manchester Metropolitan University.\n\nwww.ess.mmu.ac.uk for more information.\n\nCopyright ©2017";
    
    [self calculateButtonPressed:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self calculateButtonPressed:nil];
}

-(IBAction)calculateButtonPressed:(id)sender{
    [self doCalculations];
}

-(void) doCalculations{
//Calculations every time the values change
    
    //Total volume of drink in glass
    float totalVol = [unitsTF.text floatValue]*1000 / [abvTF.text floatValue];
    totVolLBL.text = [NSString stringWithFormat:@"%.1fml", totalVol];//ok
    
    //Vol of water in glass
    float mixVol   = totalVol * (100 - [abvTF.text floatValue]) / 100;
    mixVolLBL.text = [NSString stringWithFormat:@"%.1fml", mixVol];//ok
    
    //Vol of alc in glass
    float alcVol   = totalVol * [abvTF.text floatValue] / 100;
    alcVolLBL.text = [NSString stringWithFormat:@"%.1fml", alcVol];//ok
    
    //wt of water in glass
    float mixWt   = totalVol * (100 - [abvTF.text floatValue]) / 100 * [mixTF.text floatValue];
    mixWtLBL.text = [NSString stringWithFormat:@"%.1fg", mixWt];//
    
    //wt of alc in glass
    float alcWt   = totalVol * [abvTF.text floatValue] / 100 * [alcTF.text floatValue];
    alcWtLBL.text = [NSString stringWithFormat:@"%.1fg", alcWt];//ok
    
    //Total wt of drink in glass
    float totalWt = alcWt + mixWt;
    totWtLBL.text = [NSString stringWithFormat:@"%.1fg", totalWt];//ok
    
    //portions in bottle
    float portions   = [bottleSzTF.text floatValue] / totalVol;
    portionsLBL.text = [NSString stringWithFormat:@"%.1f", portions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //used to clear keyboard if screen touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //***** change all to suit inputs *****
    //the number refers to the scrolling of the text input field to avoid the keyboard when it appears, then it is moved back afterwards to the 0 origin
    
    //no effrect as this App is being ported to iPhone only, even though displaying on an iPad, compromise value
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
    int yy;
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
        yy=200;
    } else {
        /* do something specifically for iPhone or iPod touch. */
        yy=200;
    }
    
    // change the color of the text box when you touch it
    if(textField==self->alcTF){
        alcTF.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->mixTF){
        mixTF.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->abvTF){
        abvTF.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->unitsTF){
        unitsTF.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->bottleSzTF){
        bottleSzTF.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    
    //move the screen back to the original place
    [self keyBoardDisappeared:0];
   
    //colour change if out of range and insert range max/min value
    //set backgrounds to yellow/red if had to correct

    if ([alcTF.text floatValue] <= 0.5) {
        alcTF.textColor = [UIColor redColor];
        alcTF.text = @"0.5";
        alcTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([alcTF.text floatValue] > 1.0) {
        alcTF.textColor = [UIColor redColor];
        alcTF.text = @"1.0";
        alcTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([mixTF.text floatValue] <= 0.5) {
        mixTF.textColor = [UIColor redColor];
        mixTF.text = @"0.5";
        mixTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([mixTF.text floatValue] > 4.0) {
        mixTF.textColor = [UIColor redColor];
        mixTF.text = @"4.0";
        mixTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([unitsTF.text floatValue] <= 0.1) {
        unitsTF.textColor = [UIColor redColor];
        unitsTF.text = @"0.1";
        unitsTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([unitsTF.text floatValue] > 50.0) {
        unitsTF.textColor = [UIColor redColor];
        unitsTF.text = @"50.0";
        unitsTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([bottleSzTF.text floatValue] <= 0.1) {
        bottleSzTF.textColor = [UIColor redColor];
        bottleSzTF.text = @"0.1";
        bottleSzTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([bottleSzTF.text floatValue] > 100000.0) {
        bottleSzTF.textColor = [UIColor redColor];
        bottleSzTF.text = @"100000.0";
        bottleSzTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([abvTF.text floatValue] <= 0.1) {
        abvTF.textColor = [UIColor redColor];
        abvTF.text = @"0.1";
        abvTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([abvTF.text floatValue] > 100.0) {
        abvTF.textColor = [UIColor redColor];
        abvTF.text = @"100.0";
        abvTF.backgroundColor = [UIColor yellowColor];
    }
    //update calcs
    [self calculateButtonPressed:nil];
}

-(void) keyBoardAppeared :(int)oft
{
    //move screen up or down as needed to avoid text field entry
    CGRect frame = self.view.frame;
    
    //move frame without anim if toggle in settings indicates yes
    if (keyboardAnim == YES){
        
        //oft= the y of the text field?  make some code to find it
        [UIView animateWithDuration:keyboardAnimSpeed
                              delay:keyboardAnimDelay
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }else{
        //just move it
        self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);}
}

-(void) keyBoardDisappeared :(int)oft
{
    //move the screen back to original position
    CGRect frame = self.view.frame;
    //oft= the y of the text field?  make some code to find it
    if (keyboardAnim == YES){
        [UIView animateWithDuration:keyboardAnimSpeed
                              delay:keyboardAnimDelay
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(frame.origin.x, oft, frame.size.width, frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }else{
        //just move it
        self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);}
    
    //update calcs
    
    [self calculateButtonPressed:nil];
}


- (IBAction)alcChanged:(id)sender {
    [self doCalculations];
}
- (IBAction)mixChanged:(id)sender {
    [self doCalculations];
}
- (IBAction)abvChanged:(id)sender {
    [self doCalculations];
}
- (IBAction)unitsChanged:(id)sender {
    [self doCalculations];
}
- (IBAction)bottleChanged:(id)sender {
    [self doCalculations];
}
@end
