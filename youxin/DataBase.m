//
//  DataBase.m
//  youxin
//
//  Created by fei on 13-9-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "DataBase.h"

static DataBase *g_database = nil;
@implementation DataBase
+(DataBase *)shareDB{
    if(g_database){
        return g_database;
    }
    else{
        g_database = [[DataBase alloc] init];
        return g_database;
    }
}

-(NSString*)filePathBynm:(NSString*)snm{
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"tmp"];
    
    if(snm&&snm.length!=0){
        path = [path stringByAppendingPathComponent:snm];
    }
    return snm;
}
-(id)init{
    if(self = [super init]){
        dbFilepath = [self filePathBynm:@"db_youxin.db"];
        mDataBase = [FMDatabase databaseWithPath:dbFilepath];
        if([mDataBase open]){
            NSArray *arr = [NSArray arrayWithObjects:@"",@"", nil];
            for(NSString *sql in arr){
                [mDataBase executeUpdate:sql];
            }
        }
        
    }
    
    return self;
}

-(void)insertItem:(id)item{
    
}

@end
