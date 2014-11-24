//
//  WordsTextView.m
//  WordsTextView
//
//  Created by Sunayna Jain on 11/17/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import "WordsTextView.h"


@interface WordsTextView ()

@property BOOL cursorInBetween;
@property NSUInteger cursorLocation;

@end

@implementation WordsTextView

- (void)addWord:(NSString *)word withColor:(UIColor *)color font:(UIFont *)font
{
    NSDictionary *temp = @{@"color":color, @"font":font};
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:temp forKey:word];
    [self.words addEntriesFromDictionary:dictionary];
}

- (void)removeWord:(NSString *)word
{
    [self.words removeObjectForKey:word];
}

- (void)addWords:(NSMutableDictionary *)wordsDictionary
{
    self.words = wordsDictionary;
}

- (NSString *)wordWithOnlyLetters: (NSString *)word
{
    NSString *characterString = @"";
    NSString *newString = @"";
    for (int i=0; i<word.length; i++) {
        unichar c = [word characterAtIndex:i];
        int cIntegerValue = (int)c;
        if (cIntegerValue>=97 && cIntegerValue<=122) {
            characterString = [NSString stringWithFormat:@"%C", c];
            newString = [newString stringByAppendingString:characterString];
        } else {
            continue;
        }
    }
    return newString;
}

- (NSArray *)specialCharactersInWord:(NSString *)word
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<word.length; i++) {
        unichar character = [word characterAtIndex:i];
        NSString *characterString = [NSString stringWithFormat:@"%C", character];
        if ([self isASpecialCharacter:characterString]) {
            NSRange searchRange = NSMakeRange(i, word.length-i);
            NSRange characterRange = [word rangeOfString:characterString options:NSCaseInsensitiveSearch range:searchRange];
            NSString *string = [NSString stringWithFormat:@"%@~%d", characterString, characterRange.location];
            [array addObject:string];
        }
    }
    return array;
}

- (BOOL)isASpecialCharacter:(NSString *)text
{
    unichar c = [text characterAtIndex:0];
    int cIntegerValue = (int)c;
        if (cIntegerValue<97 || cIntegerValue>122) {
            return YES;
        } else {
            return NO;
        }
}

-(BOOL)word:(NSString *)word isAWholeWordWithRange:(NSRange)range inString:(NSString *)string
{
    NSUInteger location = range.location;
    NSInteger wordLength = word.length;
    NSUInteger afterLocation = location+wordLength;
    NSString *beforeString = @"";
    NSString *afterString = @"";
    if (afterLocation< string.length) {
        unichar afterChar = [string characterAtIndex:afterLocation];
        afterString = [NSString stringWithFormat:@"%C", afterChar];
    }
    if (location>0) {
        unichar beforeChar = [string characterAtIndex:location-1];
        beforeString = [NSString stringWithFormat:@"%C", beforeChar];
    }
    if (location>0 && afterLocation< string.length) {
        if ([self isASpecialCharacter:beforeString] && [self isASpecialCharacter:afterString]) {
            return YES;
        }
    } else if (afterLocation<= self.text.length) {
        if ([afterString isEqualToString:@""]) {
            return YES;
        }
        else if (location ==0 && [self isASpecialCharacter:afterString]) {
            return YES;
        }
    } else if (location>0) {
        if (afterLocation == self.text.length && [self isASpecialCharacter:beforeString]) {
            return YES;
        }
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *textViewText = [textView.text lowercaseString];
    if (self.cursorInBetween) {
        NSString *beforeWord = @"";
        NSString *afterWord = @"";
        int i = self.cursorLocation-1;
        int j = self.cursorLocation;
        if (i>0) {
            while (![self isASpecialCharacter:[NSString stringWithFormat:@"%C", [textViewText characterAtIndex:i]]] && i>0) {
            unichar character = [textViewText characterAtIndex:i];
            beforeWord = [beforeWord stringByAppendingString:[NSString stringWithFormat:@"%C", character]];
            i--;
            }
        }
        if (j<textView.text.length) {
            while (![self isASpecialCharacter:[NSString stringWithFormat:@"%C", [textViewText characterAtIndex:j]]] && j<textView.text.length-1) {
            unichar character = [textViewText characterAtIndex:j];
            afterWord = [afterWord stringByAppendingString:[NSString stringWithFormat:@"%C", character]];
            j++;
            }
        }
        beforeWord = [self reverseWord:beforeWord];
        [self checkWord:beforeWord];
        [self checkWord:afterWord];
    } else {
        //cursor at end
        if ([textViewText containsString:[self whiteSpace]]) {
            NSArray *words = [textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *selectedWord = [words lastObject];
            [self checkWord:selectedWord];
        } else {
            [self checkWord:textViewText];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    if (isBackSpace == -8) {
        // is backspace
        return YES;
    }
    if ([self isASpecialCharacter:text]) {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    }
    self.cursorLocation = range.location;
    if (textView.text.length>range.location) {
        //cursor in between
        self.cursorInBetween = YES;
    } else {
        self.cursorInBetween = NO;
        //cursor at end
    }
    return YES;
}

- (NSString *)reverseWord:(NSString *)word
{
    NSString *result = @"";
    NSUInteger len = [word length];
    for(int i=len-1;i>=0;i--)
    {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%C",[word characterAtIndex:i]]];
    }
    return result;
}

- (void)checkWord:(NSString *)word
{
    NSMutableAttributedString *string= [self.attributedText mutableCopy];
    NSString *wordToCheck = [word lowercaseString];
    NSString *selectedWord = [self wordWithOnlyLetters:wordToCheck];
    NSArray *specialCharacters = [self specialCharactersInWord:wordToCheck];
    NSUInteger originalWordLength = word.length;
    NSDictionary *dictionary = [self.words objectForKey:selectedWord];
    UIColor *color = [dictionary objectForKey:@"color"];
    UIFont *font = [dictionary objectForKey:@"font"];
    NSUInteger wordLength = selectedWord.length;
    if ([[self.words allKeys] containsObject:selectedWord]) {
        BOOL keepGoing = YES;
        NSRange searchRange = NSMakeRange(0, [self.text length]);
        while (keepGoing) {
            NSRange wordRange = [self.text rangeOfString:selectedWord options:NSCaseInsensitiveSearch range:searchRange];
            NSRange range = [self.text rangeOfString:wordToCheck options:NSCaseInsensitiveSearch range:searchRange];
            if (wordRange.location != NSNotFound) {
                NSUInteger pos = wordRange.location + wordLength;
                searchRange = NSMakeRange(pos, [self.text length] - pos);
                if ([self word:selectedWord
         isAWholeWordWithRange:wordRange
                      inString:self.text]) {
                  [string addAttribute:NSForegroundColorAttributeName value:color range:wordRange];
                    [string addAttribute:NSFontAttributeName value:font range:wordRange];
                    if (selectedWord.length < wordToCheck.length) {
                        for (NSString *characterString in specialCharacters) {
                            NSString *locationString = [[characterString componentsSeparatedByString:@"~"] lastObject];
                            NSUInteger location = locationString.integerValue;
                            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(range.location+location, 1)];
                            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location+location, 1)];
                        }
                    }
                }
            } else {
                keepGoing = NO;
            }
        }
    } else {
        if (!self.cursorInBetween) {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(self.text.length-originalWordLength, originalWordLength)];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(self.text.length-originalWordLength, originalWordLength)];
        }
    }
    self.attributedText = string;
}

- (void)highlightText
{
    NSString *text = self.text;
    NSArray *words = [text componentsSeparatedByString:[self whiteSpace]];
    for (NSString *word in words) {
        NSString *wordCopy = [word mutableCopy];
        wordCopy = [wordCopy lowercaseString];
        wordCopy = [self wordWithOnlyLetters:wordCopy];
        [self checkWord:wordCopy];
    }
}

- (NSString *)whiteSpace
{
    return @" ";
}

@end
