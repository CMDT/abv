//
//  ViewController.m
//  abv
//
//  Created by Jon Howell on 10/02/2017.
//  Copyright © 2017 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "ViewController.h"

#define kVersion0   @"version0" //for settings bundle messages
#define kVersion1   @"version1"
#define kVersion2   @"version2"
#define kVersion3   @"version3"

@interface ViewController ()

@end

@implementation ViewController{
    BOOL  keyboardAnim;
    BOOL  volFlag; //if user entered a volume rather than the units, it is set YES
    float keyboardAnimSpeed;
    float keyboardAnimDelay;
    
    float totVol;
    float mixVol;
    float alcVol;
    float units;
    float alcWt;
    float mixWt;
    float totalVol;
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
    totVolTF,
    calculate,
    informationText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //for plist version group
    NSString * version0; //version number
    NSString * version1; //copyright info
    NSString * version2; //author info
    NSString * version3; //web site info
    
    NSString        * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString        * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString        * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary    * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults  * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //*************************************************************
    //version, set anyway *****************************************
    //*************************************************************
    version0 = @"1.0.3 - 13th Feb 2017";       // version no and date of build
    version1 = @"MMU (C) 2017";                // copyright *** limited line space
    version2 = @"j.a.howell@mmu.ac.uk";        // author    *** to display on device
    version3 = @"http://www.ess.mmu.ac.uk";    // web site  *** settings screen
    //*************************************************************
    //update settings bundle
    [defaults setObject:version0 forKey:kVersion0];   //***
    [defaults setObject:version1 forKey:kVersion1];   //***
    [defaults setObject:version2 forKey:kVersion2];   //***
    [defaults setObject:version3 forKey:kVersion3];   //***
    //*************************************************************
    //version set end *********************************************
    //*************************************************************
    
    [defaults synchronize];
    
    keyboardAnim      = YES;
    volFlag           = NO;
    keyboardAnimSpeed = 0.2;
    keyboardAnimDelay = 0.1;
    
    alcTF.delegate      = self;
    mixTF.delegate      = self;
    unitsTF.delegate    = self;
    bottleSzTF.delegate = self;
    abvTF.delegate      = self;
    totVolTF.delegate   = self;
    
    totVolTF.backgroundColor   = [UIColor colorWithRed:200 green:240 blue:200 alpha:(1.0)];
    
    //add text to information screen
    informationText.text=@"This calculator will give you the volume and weight of beverage for a fixed number of UK alcohol units, taking into account the specific gravity (S.G.) of the alcohol mix (ethanol/other alcohols), and the base carrier (usually water).\n\nYou may need to adjust the S.G.'s of both depending upon the sugar and solids content of the components, as the weights and values will change dependent upon the alteration of the S.G. of the substances involved.\n\nA Unit of Alcohol is 10ml of pure alcohol or 7.87g of pure alcohol.\n\nFrom the beverage product information, look for the ABV value in %, and enter it in the ABV field.\n\nEnter the number of Alcohol Units you wish to calculate the volume and weight data.\n\nPlease NOTE:\n\nThis calculator is NOT to be used for clinical or legal purposes.\n\nThis calculator is for Educational and learning purposes only, and any actual consumption of alcohol is purely the responsibility of the consumer and NOT  in any way this application.\n\nThis App developed by Jonathan Howell, Manchester Metropolitan University.\n\nwww.ess.mmu.ac.uk for more information.\n\nCopyright ©2017";
    
    [self calculateButtonPressed:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self calculateButtonPressed:nil];
}

-(IBAction)calculateButtonPressed:(id)sender{
    if (volFlag == YES) {
        //was volume of drink entered
        [self doCalculations2];
    }else{
        //was units entered
        [self doCalculations];
    }
}

-(void) doCalculations{
//Calculations every time the values change
    //Normal calc for units entered
    //Total volume of drink in glass
    totalVol = [unitsTF.text floatValue]*1000 / [abvTF.text floatValue];
    totVolTF.text = [NSString stringWithFormat:@"%.1f", totalVol];//ok
    
    [self doCommonCalcs];
    
    //colour the boxes to show which was calculated and which was entered
    totVolTF.backgroundColor   = [UIColor greenColor];
    totVolTF.textColor         = [UIColor blackColor];
}

-(void) doCalculations2{
    //Calculations every time the volume value changes
    //Total volume of drink in glass
    totalVol = [totVolTF.text floatValue];
    
    [self doCommonCalcs];

    //work out the units
    units = alcWt / [alcTF.text floatValue] / 10;
    unitsTF.text = [NSString stringWithFormat:@"%.2f", units];
    
    unitsTF.backgroundColor      = [UIColor greenColor];
    //totVolTF.backgroundColor   = [UIColor whiteColor];
    //totVolTF.textColor         = [UIColor blackColor];
}

-(void)doCommonCalcs{
    //same for both options of volume entered or units entered
    //Vol of water in glass
    mixVol   = totalVol * (100 - [abvTF.text floatValue]) / 100;
    mixVolLBL.text = [NSString stringWithFormat:@"%.1f", mixVol];//ok
    
    //Vol of alc in glass
    alcVol   = totalVol * [abvTF.text floatValue] / 100;
    alcVolLBL.text = [NSString stringWithFormat:@"%.1f", alcVol];//ok
    
    //wt of water in glass
    mixWt   = totalVol * (100 - [abvTF.text floatValue]) / 100 * [mixTF.text floatValue];
    mixWtLBL.text = [NSString stringWithFormat:@"%.1f", mixWt];//
    
    //wt of alc in glass
    alcWt   = totalVol * [abvTF.text floatValue] / 100 * [alcTF.text floatValue];
    alcWtLBL.text = [NSString stringWithFormat:@"%.1f", alcWt];//ok
    
    //Total wt of drink in glass
    float totalWt = alcWt + mixWt;
    totWtLBL.text = [NSString stringWithFormat:@"%.1f", totalWt];//ok
    
    //portions in bottle
    float portions   = [bottleSzTF.text floatValue] / totalVol;
    portionsLBL.text = [NSString stringWithFormat:@"%.2f", portions];
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
    volFlag = NO; //ordinary calcs based on UNITS only, Vol calculated
    
    // change the color of the text box when you touch it
    if(textField==self->alcTF){
        alcTF.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->mixTF){
        mixTF.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->abvTF){
        abvTF.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->unitsTF){
        unitsTF.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->bottleSzTF){
        bottleSzTF.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->totVolTF){
        totVolTF.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
        volFlag = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    
    //move the screen back to the original place
    [self keyBoardDisappeared:0];
    
    alcTF.backgroundColor       = [UIColor whiteColor];
    mixTF.backgroundColor       = [UIColor whiteColor];
    abvTF.backgroundColor       = [UIColor whiteColor];
    bottleSzTF.backgroundColor  = [UIColor whiteColor];
    
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
    
    if ([totVolTF.text floatValue] <= 0.1) {
        totVolTF.textColor = [UIColor redColor];
        totVolTF.text = @"0.1";
        totVolTF.backgroundColor = [UIColor yellowColor];
    }
    
    if ([totVolTF.text floatValue] > 10000.0) {
        totVolTF.textColor = [UIColor redColor];
        totVolTF.text = @"10000.0";
        totVolTF.backgroundColor = [UIColor yellowColor];
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
- (IBAction)volChanged:(id)sender {
    [self doCalculations2];
}
@end
