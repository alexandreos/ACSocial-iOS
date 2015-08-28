//
//  ACDictionaryDeserializable.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ACDictionaryDeserializable <NSObject>

/**
 Initialize the current object with the given dictionary
 
 @param dictionary The NSDictionary instance to be used for the initialization.
 
 @return The initialized instance.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
