//
//  IMMacroToolbox.h
//  PieChart
//
//  Created by Ivan Mejia on 12/29/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

#ifndef PieChart_IMMacroToolbox_h
#define PieChart_IMMacroToolbox_h

// helpers to get more interesing colors
#define IMOpaqueHexColor(c) [UIColor colorWithRed:((c >> 16) & 0xff)/255.0 green:((c >> 8) & 0xff)/255.0 blue:(c & 0xff)/255.0 alpha:1.0]
#define IMTranslucidHexColor(c,a) [UIColor colorWithRed:((c >> 16) & 0xff)/255.0 green:((c >> 8) & 0xff)/255.0 blue:(c & 0xff)/255.0 alpha:a]

// logging and assertion macros
#ifdef DEBUG
#define im_log(format,...) NSLog(format,##__VA_ARGS__)
#define im_assert(condition) assert(condition)
#else
#define im_log(format,...)
#define im_assert(condition)
#endif

#endif
