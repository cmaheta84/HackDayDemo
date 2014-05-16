//
//  ViewController.m
//  Demo
//
//  Created by Chandni Maheta on 5/15/14.
//  Copyright (c) 2014 Chandni Maheta. All rights reserved.
//

#import "ViewController.h"
#import "WordData.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (retain, nonatomic) UIView *finderView;

@property(nonatomic, retain) NSMutableArray *wordsArray;
@property(nonatomic, retain) NSMutableArray *rangeArray;
@end

@implementation ViewController

@synthesize textField = _textField;
@synthesize wordsArray;
@synthesize rangeArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    self.finderView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-67,self.view.frame.size.width,67)];
	// Do any additional setup after loading the view, typically from a nib.
    // Add wiki button to UIMenuController
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *wikiItem = [[UIMenuItem alloc] initWithTitle:@"Find" action:@selector(find:)];
    [menuController setMenuItems:[NSArray arrayWithObject:wikiItem]];
    
    UIImageView *photoImg =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height/3*2+100)];
    photoImg.contentMode = UIViewContentModeScaleToFill;
    photoImg.image=[UIImage imageNamed:@"photo1.png"];
    photoImg.opaque = YES;
    [self.textField addSubview:photoImg];
    
    UIImageView *prevImg =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,20)];
    prevImg.image=[UIImage imageNamed:@"leftarrow2.png"];
    prevImg.opaque = YES;
    UIImageView *nextImg =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,20)];
    nextImg.image=[UIImage imageNamed:@"rightarrow2.png"];
    nextImg.opaque = YES;

    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    prevButton.frame = CGRectMake(10, 35, 10, 20); // position in the parent view and set the size of the button
    [prevButton addSubview:prevImg];
    [prevButton addTarget:self action:@selector(prevClicked:) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setBackgroundColor: [self colorWithHexString:@"F3F3F3"]];
    [self.finderView addSubview:prevButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.frame = CGRectMake(35, 35, 10, 20); // position in the parent view and set the size of the button
    [nextButton addSubview:nextImg];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.finderView addSubview:nextButton];
    [self.finderView setBackgroundColor: [self colorWithHexString:@"F3F3F3"]];

    UIColor *borderColor = [self colorWithHexString:@"808080"];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.finderView.frame.size.width, 1)];
    topView.opaque = YES;
    topView.backgroundColor = borderColor;
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.finderView addSubview:topView];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.finderView.frame.size.width-10, 20)];
    tf.font = [UIFont fontWithName:@"Helvetica" size:18];
    tf.backgroundColor=[UIColor whiteColor];
    tf.text=@"Hello World";
    tf.layer.borderColor=[[UIColor whiteColor] CGColor];
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.layer.borderWidth = 1.0;
    tf.tag = 100;
    [self.finderView addSubview:tf];
    
    UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(60, 35, 100, 20)];
    tf2.font = [UIFont fontWithName:@"Helvetica" size:13];
    tf2.text = @"1 of 9 match";
    tf2.tag = 200;
    [self.finderView addSubview:tf2];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(self.finderView.frame.size.width-50, 35, 40, 20);
    [doneButton setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.finderView addSubview:doneButton];
    
    //[self.finderView setFrame:CGRectMake(0, 0,self.view.frame.size.width, 65)];
    //[self.finderView.superview bringSubviewToFront:self.finderView];
    
    self.finderView.hidden = YES ;
    [self.view addSubview:self.finderView];
    wordsArray = [[NSMutableArray alloc] init];
    rangeArray = [[NSMutableArray alloc] init];
}

- (void) doneClicked:(id) sender {
    [wordsArray removeAllObjects];
    [self.textField setFrame:CGRectMake(0, 50, self.textField.frame.size.width, self.textField.frame.size.height+50)];
    self.finderView.hidden = YES ;
    NSRange range;
    [self.textField select:self];
    [self.textField setSelectedRange:range];
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prevClicked:(id)sender {
    if([self sameText] == 0) {
        UITextField *tf = (UITextField *)[self.finderView viewWithTag:100];
        [self fillUpWordsData:tf.text];
        NSRange range = NSMakeRange(0, 0);
        [self.textField setSelectedRange:range];
    }
    
    NSInteger total = wordsArray.count;
    NSInteger index = 0;
    NSRange range = [WordData getPrevWordRange:self.textField.selectedRange :wordsArray:&index];
    NSString *inStr = [@(index) stringValue];
    NSString *totStr = [@(total) stringValue];
    NSString *status = [[inStr stringByAppendingString:@" match of "]stringByAppendingString:totStr];
    UITextField *tf = (UITextField *)[self.finderView viewWithTag:200];
    tf.text = status;

    [self.textField select:self];
    [self.textField setSelectedRange:range];
    range.location += 200;
    [self.textField scrollRangeToVisible:range];
    [self.finderView reloadInputViews];
}

-(NSInteger) sameText {
    NSString *selectedText = [_textField textInRange:_textField.selectedTextRange];
    UITextField *tf = (UITextField *)[self.finderView viewWithTag:100];
    
    if([selectedText isEqualToString:tf.text]) {
        return 1;
    } else {
        return 0;
    }
}

- (void) nextClicked:(id)sender {
    if([self sameText] == 0) {
        UITextField *tf = (UITextField *)[self.finderView viewWithTag:100];
        [self fillUpWordsData:tf.text];
        NSRange range = NSMakeRange(0, 0);
        [self.textField setSelectedRange:range];
    }
    
    NSInteger total = wordsArray.count;
    NSInteger index = 0;

    NSRange range = [WordData getNextWordRange:self.textField.selectedRange :wordsArray:&index];
    
    NSString *inStr = [@(index) stringValue];
    NSString *totStr = [@(total) stringValue];
    NSString *status = [[inStr stringByAppendingString:@" match of "]stringByAppendingString:totStr];
    UITextField *tf = (UITextField *)[self.finderView viewWithTag:200];
    tf.text = status;
    [self.textField select:self];
    [self.textField setSelectedRange:range];
    if(range.location>200) {
    range.location += 200;
    }
    
    [self.textField scrollRangeToVisible:range];
    [self.finderView reloadInputViews];
}

- (void) fillUpWordsData :(NSString *) userInput{
    [wordsArray removeAllObjects];
    NSString *selectedText = userInput;//[_textField textInRange:_textField.selectedTextRange];
    UITextField *tf = (UITextField *)[self.finderView viewWithTag:100];
    tf.text = selectedText;
    [self.textField.text enumerateSubstringsInRange:NSMakeRange(0, [self.textField.text length]) options:NSStringEnumerationByWords usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingRange, BOOL* stop){
        
        if([word isEqualToString:selectedText]) {
            WordData *currentWord = [[WordData alloc]init];
            currentWord.word = word;
            currentWord.wordRange = wordRange;
            [wordsArray addObject:currentWord];
        }
    }];

}

- (void)keyboardDidShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.finderView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardSize.height-self.finderView.frame.size.height,self.finderView.frame.size.width, self.finderView.frame.size.height)];
    [self reloadInputViews];
}

- (void)keyboardDidHide:(NSNotification*)notification {
    [self.finderView setFrame:CGRectMake(0,self.view.frame.size.height-67,self.view.frame.size.width,67)];
}

- (void)find:(id)sender {
    NSString *selectedText = [_textField textInRange:_textField.selectedTextRange];
    [self fillUpWordsData:selectedText];
    [self.textField setFrame:CGRectMake(0, 50, self.textField.frame.size.width, self.textField.frame.size.height-50)];
    self.finderView.hidden = NO;
    NSInteger total = wordsArray.count;
    NSInteger index = 0;
    
    NSRange range = [WordData getNextWordRange:self.textField.selectedRange :wordsArray:&index];
    
    NSString *inStr = [@(index) stringValue];
    NSString *totStr = [@(total) stringValue];
    NSString *status = [[inStr stringByAppendingString:@" match of "]stringByAppendingString:totStr];
    
    UITextField *tf = (UITextField *)[self.finderView viewWithTag:200];
    tf.text = status;
    [self.textField select:self];
    [self.textField setSelectedRange:range];
    range.location += 200;
    [self.textField scrollRangeToVisible:range];
}
@end
