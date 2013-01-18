//
//  rDatenlegende.m
//  WebInterface
//
//  Created by Ruedi Heimlicher on 18.Januar.13.
//
//

#import "rDatenlegende.h"

@implementation rDatenlegende

- (id)init
{
   self = [super init];
   LegendeArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   randunten=0;
   randoben = 0;
   abstandoben=10;
   abstandunten=10;
   distanz = 10;
   return self;
}

- (void)setVorgabenDic:(NSDictionary*)vorgabendic
{
   //float randunten, randoben, abstandunten, abstandoben;
if ([vorgabendic objectForKey:@"randunten"])
{
   randunten = [[vorgabendic objectForKey:@"randunten"]floatValue];
}
   if ([vorgabendic objectForKey:@"randoben"])
   {
      randoben = [[vorgabendic objectForKey:@"randoben"]floatValue];
   }
   if ([vorgabendic objectForKey:@"abstandunten"])
   {
      abstandunten = [[vorgabendic objectForKey:@"abstandunten"]floatValue];
   }
   if ([vorgabendic objectForKey:@"abstandoben"])
   {
      abstandoben = [[vorgabendic objectForKey:@"abstandoben"]floatValue];
   }

   if ([vorgabendic objectForKey:@"distanz"])
   {
      distanz = [[vorgabendic objectForKey:@"distanz"]floatValue];
   }

}

- (void)setLegendeArray:(NSArray*)legendearray
{
   
   // Array mit Dics zu jedem Cluster: Array mit Elementen, abstaende usw
   NSMutableArray* ClusterArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   //LegendeArray = [NSMutableArray arrayWithArray:array];
   
   // Abstande einsetzen
   float lastposition=randunten;
   int clusterindex = 0;
   
   [ClusterArray addObject:[[[NSMutableArray alloc]initWithCapacity:0]autorelease]];
   
   for (int i=0;i<[legendearray count];i++)
   {
      float tempwert = [[[legendearray objectAtIndex:i]objectForKey:@"wert"]floatValue];
      int legendeposition = (int)tempwert;
      if (tempwert <= lastposition) // zum letzten Objekt in ClusterArray zufuegen
      {
         legendeposition = lastposition;
         if (i) // nicht unterste Position
         {
            
            if ([[ClusterArray lastObject]count]==0) // Array noch leer, vorheriges Objekt zufuegen
            {
               NSMutableDictionary* clusterDic = [LegendeArray lastObject];
               [clusterDic setObject:[NSNumber numberWithInt:clusterindex] forKey:@"clusterindex"];
               
               [[ClusterArray lastObject]addObject:clusterDic];

            }
            
            NSMutableDictionary* clusterDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                               [NSNumber numberWithInt:legendeposition],@"legendeposition",
                                                [NSNumber numberWithInt:clusterindex],@"clusterindex",
                                               [NSNumber numberWithFloat:tempwert],@"wert",
                                                
                                                nil];
            [[ClusterArray lastObject]addObject:clusterDic];
         }
      }
      else
      {
         lastposition = tempwert;
         // Cluster fertig, neuen Array anfuegen
         if ([[ClusterArray lastObject]count]) // der letzte Cluster hatte Objecte
         {
            [ClusterArray addObject:[[[NSMutableArray alloc]initWithCapacity:0]autorelease]];
            clusterindex ++;
         }
         
      }
      
      
      [LegendeArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:tempwert], @"wert",
                              [NSNumber numberWithInt:legendeposition], @"legendeposition",
                              nil]];
      NSLog(@"DatenLegende i: %d tempwert: %.2f legendeposition: %d",i,tempwert,legendeposition);
      lastposition += distanz;
   }// for i
   
   //NSLog(@"DatenLegende LegendeArray: %@",[[LegendeArray valueForKey:@"legendeposition"]description]);
   
   for (int k=0;k<[ClusterArray count];k++)
   {
      NSLog(@"DatenLegende k: %d ClusterArray: %@",k,[[ClusterArray objectAtIndex:k ]description]);
   }
   //NSLog(@"DatenLegende ClusterArray: %@",[ClusterArray description]);
   

}



- (NSArray*)LegendeArray
{
   
   return LegendeArray;
}

@end
