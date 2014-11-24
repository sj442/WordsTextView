//
//  ViewController.m
//  WordsTextView
//
//  Created by Sunayna Jain on 11/17/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import "ViewController.h"
#import "WordsTextView.h"
#import "WordsTextField.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet WordsTextField *textfield;
@property (weak, nonatomic) IBOutlet WordsTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textView.delegate = self.textView;
    self.textView.myDelegate = self.textView;
    
    self.textfield.delegate = self.textfield;
    self.textfield.myDelegate = self.textfield;

    UIColor *yellow = [UIColor yellowColor];
    UIColor *red = [UIColor redColor];
    UIColor *green = [UIColor greenColor];
    UIColor *blue = [UIColor blueColor];
    UIColor *gray = [UIColor grayColor];
    
    [self.textView addWords:[NSDictionary dictionaryWithObjects:@[@{@"color":yellow, @"font":[UIFont fontWithName:@"Zapfino" size:12]}, @{@"color":red, @"font":[UIFont fontWithName:@"Verdana-Bold" size:14]}, @{@"color":gray, @"font":[UIFont fontWithName:@"Helvetica-Oblique" size:16]}, @{@"color":green, @"font":[UIFont fontWithName:@"Arial" size:18]}, @{@"color":blue, @"font":[UIFont fontWithName:@"Courier" size:12]}] forKeys:@[@"hi", @"yes", @"why", @"you", @"me"]]];
    
    [self.textfield addWords:[NSDictionary dictionaryWithObjects:@[@{@"color":yellow, @"font":[UIFont fontWithName:@"Zapfino" size:12]}, @{@"color":red, @"font":[UIFont fontWithName:@"Verdana-Bold" size:14]}, @{@"color":gray, @"font":[UIFont fontWithName:@"Helvetica-Oblique" size:16]}, @{@"color":green, @"font":[UIFont fontWithName:@"Arial" size:18]}, @{@"color":blue, @"font":[UIFont fontWithName:@"Courier" size:12]}] forKeys:@[@"hi", @"yes", @"why", @"you", @"me"]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.textfield.text = @"Hi. this is me. How are you? and me and I am we and why are you? and me me me?";
    [self.textfield.myDelegate highlightText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
