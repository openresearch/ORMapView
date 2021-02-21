//
//  NSObject+ORDebounce.h
//  OEAMTCLib
//
//  Created by Andy Matuschak on 8/27/09.
//  Public domain because I love you.
//

#import <Foundation/Foundation.h>

@interface NSObject (ORDebounce)

- (void)performSelectorOnMainThreadOnce:(SEL)selector;

@end
