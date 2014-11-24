//
//  WordsTextField.h
//  WordsTextView
//
//  Created by Sunayna Jain on 11/24/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myDelegate <NSObject>

- (void)highlightText;

@end

@interface WordsTextField : UITextField <UITextFieldDelegate, myDelegate>

@property (strong, nonatomic) NSMutableDictionary *words;

@property  (weak, nonatomic) id <myDelegate> myDelegate;

- (void)addWord:(NSString *)word withColor:(UIColor *)color font:(UIFont *)font;
- (void)removeWord:(NSString *)word;
- (void)addWords:(NSDictionary *)wordsDictionary;


@end
