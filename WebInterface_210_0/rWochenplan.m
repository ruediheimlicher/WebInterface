//
//  rWochenplan.m
//  USBInterface
//
//  Created by Sysadmin on 05.06.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rWochenplan.h"
#import "rTagplan.h"
#import "rTagplanbalken.h"
#import "rModeTagplanbalken.h"
#import "rServoTagplanbalken.h"
#import "rDatenbalken.h"

#define WOCHENPLANOFFSET	2000
#define RAUMOFFSET			1000
@implementation rWochenplan


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
	TagplanArray=[[NSMutableArray alloc]initWithCapacity:0];
	aktivObjektArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSNotificationCenter*	nc=[NSNotificationCenter defaultCenter];
		
	[nc addObserver:self
		   selector:@selector(ModifierAktion:)
			   name:@"Modifier"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(WriteWochenplanModifierAktion:)
			   name:@"WriteWochenplanModifier"
			 object:nil];
			 
      [nc addObserver:self
             selector:@selector(daySettingAktion:)
                 name:@"daysetting"
               object:nil];
			 



    }
    return self;
}

- (void)daySettingAktion:(NSNotification*)note
{
   //NSLog(@"Wochenplan daySettingAktion: %@",[[note userInfo]description]);
   daySettingStringArray = [[note userInfo]objectForKey:@"daysettingarray"];
}

- (NSArray*)setWochenplanForRaum:(int)derRaum mitWochenplanArray:(NSArray*)derWochenplanArray
{
	NSMutableDictionary* GeometrieDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	NSMutableArray* GeometrieArray=[[NSMutableArray alloc]initWithCapacity:0];

	NSArray* Wochentage=[NSArray arrayWithObjects:@"M<",@"DI", @"MI", @"DO", @"FR", @"SA", @"SO",nil];
	NSArray* Raumnamen=[NSArray arrayWithObjects:@"Heizung", @"Werkstatt", @"WoZi", @"Buero", @"Labor", @"OG1", @"OG2", @"Estrich", nil];
	//NSLog(@"\n\nsetWochenplanForRaum: : %d    start",derRaum);
	//NSLog(@"setWochenplanForRaum: derWochenplanArray: %@",[derWochenplanArray description]);
	//NSLog(@"A0");
	//NSLog(@"Raum: %@",[Raumnamen objectAtIndex:derRaum]);
	//Array mit aktiven Tagbalken einrichten
	int wd;
	int obj;
	Raum=derRaum;
	//Set mit Indices der aktiven Tagplaene erstellen
	NSMutableIndexSet* aktivSet=[NSMutableIndexSet indexSet];
	//Array mit Indices der aktiven Tagplaene erstellen
	//	NSMutableArray* aktivObjektArray=[[NSMutableArray alloc]initWithCapacity:0];
	// Tagplanarray vom Montag, zum Auffinden der aktiven Tagplaene
	NSArray* tempMontagplanArray=[[derWochenplanArray objectAtIndex:0]objectForKey:@"tagplanarray"];
	//printf("raum: %d\n",Raum);
   for (obj=0;obj<8;obj++)
	{
		if ([[[tempMontagplanArray objectAtIndex:obj]objectForKey:@"aktiv"]intValue]) // Tagplan am ersten Wochentag ist aktiv
		{
			[aktivObjektArray addObject:[NSNumber numberWithInt:obj]]; // index des aktiven Objekts merken
			[aktivSet addIndex:obj];
		}
	} // for obj
	//NSLog(@"aktivObjektArray: %@",[aktivObjektArray  description]);
	//NSLog(@"aktivSet: %@",[aktivSet  description]);
	anzAktiv=[aktivObjektArray count];
	//NSLog(@"setWochenplanForRaum  anzAktiv: %d",anzAktiv);
	
	
	//Array mit Arrays der aktiven Stundenplanarrays (aktivTagplanArray) der Wochentage
	NSMutableArray* aktivTagplanDicArray=[[NSMutableArray alloc]initWithCapacity:0]; 	
	for (wd=0;wd<7;wd++)
	{
      //NSLog(@"A wd: %d",wd);
		//Tagplanarray fuer den Tag wd:
		NSArray* tempTagplanArray=[[derWochenplanArray objectAtIndex:wd]objectForKey:@"tagplanarray"];
      if (wd == 0)
      {
         //NSLog(@"Tag: %d tempTagplanArray: %@",wd, [tempTagplanArray  description]);
      }
		// Sammel-Array mit StundenplanDicArrays des Tages wd:
		NSMutableArray* aktivStundenplanDicArray=[[NSMutableArray alloc]initWithCapacity:0]; 
		
		
		
		// aktive Tagplaene durchgehen
		for (obj=0;obj<8;obj++)
		{
         
			NSMutableDictionary* tempaktivObjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			if ((derRaum == 0)&&(wd==0))
			{
            //NSLog(@"tempTagplanArray: %@",[tempTagplanArray description]);
			}
         //NSLog(@"B");
         //NSLog(@"wd: %d obj: %d tempTagplanArray: %@",wd, obj, [[tempTagplanArray objectAtIndex:obj]  description]);
         if ([[tempTagplanArray objectAtIndex:obj]objectForKey:@"tagbalkentyp"])
         {
			[tempaktivObjektDic setObject:[[tempTagplanArray objectAtIndex:obj]objectForKey:@"tagbalkentyp"] forKey:@"tagbalkentyp"];
         }
         else
         {
            [tempaktivObjektDic setObject:[NSNumber numberWithInt:0] forKey:@"tagbalkentyp"];
         }
			//NSLog(@"wd: %d obj: %d tagbalkentyp: %d",wd, obj, [[[tempTagplanArray objectAtIndex:obj]objectForKey:@"tagbalkentyp"]intValue]);
			//NSLog(@"C");
			if ([aktivSet containsIndex:obj])
			{
				//Dic mit Namen und Stundenplanarray eines aktiven Objekts
				
				// Stundenplanarray anfuegen
            
            // daySettings abfragen
   //         NSArray* tempSettingArray = [self 
            
				[tempaktivObjektDic setObject:[[tempTagplanArray objectAtIndex:obj]objectForKey:@"stundenplanarray"] forKey:@"stundenplanarray"];
				[tempaktivObjektDic setObject:[[tempTagplanArray objectAtIndex:obj]objectForKey:@"objektname"] forKey:@"objektname"];
				[tempaktivObjektDic setObject:[[tempTagplanArray objectAtIndex:obj]objectForKey:@"objekt"] forKey:@"objekt"];
				[tempaktivObjektDic setObject:[[tempTagplanArray objectAtIndex:obj]objectForKey:@"tagbalkentyp"] forKey:@"tagbalkentyp"];
				[tempaktivObjektDic setObject:[NSNumber numberWithInt:derRaum] forKey:@"raum"];
				if (obj==1 )
				{
               //NSLog(@"tempTagplanArray: %@",[[tempTagplanArray objectAtIndex:obj]  description]);
               //printf("wd: %d\t",wd);
               //[self stundenplanzeigen:[[tempTagplanArray objectAtIndex:obj]objectForKey:@"stundenplanarray"]];
					//NSLog(@"tempaktivObjektDic: %@",[tempaktivObjektDic  description]);
				}
				[aktivStundenplanDicArray addObject:tempaktivObjektDic];
				
			}// if
		}// for obj
      //NSLog(@"D");
		//NSLog(@"Tag: %d Anzahl Stundenplaene: %d",wd, [aktivStundenplanArray count]);
		
		// Array der Dics mit Objektnamen und Stundenplanen aller aktiven Objekte des Tages wd anfuegen.
		[aktivTagplanDicArray addObject:aktivStundenplanDicArray];
	}//for wd
	
	//NSLog(@"\n				****\n");
	
	
	NSMutableArray* TagbalkenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	int Tagbalkenhoehe=32;	//Hoehe eines Tagbalkens
	int Titelhoehe=30;	// Hoehe des Titelfeldes über den Tagbalken ("Wochentag")
	int Tagplanhoehe=anzAktiv*(Tagbalkenhoehe+4)+Titelhoehe;	// Hoehe des Tagplanfeldes mit den 8 Tagbalken
	int TagplanAbstand=Tagplanhoehe+8;	// Abstand zwischen den Ecken der Tagplanfelder
	
	NSRect PlanFeld;	// Feld eines Tagplanfeldes
	PlanFeld.origin.x=5;
	//	PlanFeld.origin.y=[self frame].origin.y+[self frame].size.height-TagplanAbstand-5; //erster Plan oben
	PlanFeld.origin.y=[self frame].size.height-Tagplanhoehe-8; //erster Plan oben
	PlanFeld.size.width=[self frame].size.width-20;
	PlanFeld.size.height=Tagplanhoehe;
   

	int PlanfeldLevel=PlanFeld.origin.y - TagplanAbstand; //Ecke links unten des obersten Tagplans
	int wochentag;
	for (wochentag=0;wochentag<7;wochentag++)	// 7 Tagplaene erstellen
	{
		//NSLog(@"Bueroplan awake wochentag:%d : x: %2.2f y: %2.2f height: %2.2f width: %2.2f",tag,BueroplanFeld.origin.x,BueroplanFeld.origin.y,BueroplanFeld.size.height,BueroplanFeld.size.width);
		//NSMutableDictionary* TagplanPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		//NSLog(@"Wochentage %@",[Wochentage objectAtIndex:wochentag]);
       
		NSRect Balkenfeld=PlanFeld;
		// Feld fuer die Tagplanbalken
		rTagplan* Tagplan=[[rTagplan alloc]initWithFrame:Balkenfeld];
		[Tagplan setWochentag:wochentag];
		[Tagplan setRaum:derRaum];
      [self addSubview:Tagplan];
		
		[GeometrieArray insertObject:[NSNumber numberWithFloat:Balkenfeld.origin.y] atIndex:0];
		//[GeometrieArray addObject:[NSNumber numberWithFloat:Balkenfeld.origin.y]];
		
		Balkenfeld.size.height=Tagbalkenhoehe;
		Balkenfeld.size.width-=10;
		Balkenfeld.origin.x+=2;
		Balkenfeld.origin.y+= (PlanFeld.size.height - Tagbalkenhoehe - Titelhoehe+2);
		NSMutableArray* tempTagbalkenArray=[[NSMutableArray alloc]initWithCapacity:0];
		//[GeometrieArray insertObject:[NSNumber numberWithFloat:Balkenfeld.origin.y] atIndex:0];
		//[GeometrieArray addObject:[NSNumber numberWithFloat:Balkenfeld.origin.y]];

		
		int objektbalken;
		
		//NSLog(@"setWochenplanForRaum A tag: %d",wochentag);
		for (objektbalken=0;objektbalken<anzAktiv;objektbalken++)	//Objektbalken erstellen
		{
			//NSLog(@"setWochenplanForRaum C objektbalken: %d",objektbalken);
			//objektbalken=[einIndex intValue];
			NSMutableDictionary* TagbalkenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[TagbalkenArray addObject:TagbalkenDic];
			
			// Tagbalken erzeugen
			id ObjektTagplanbalken;
			NSString* tempTitel;
			int TagbalkenTyp=0;
			if ([[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"tagbalkentyp"])
			{
			
            
			}
			else
			{
				NSLog(@"setWochenlan: kein TagbalkenTyp");
			}
			TagbalkenTyp=[[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"tagbalkentyp"]intValue];
			
			if (derRaum==2 && objektbalken==1)
			{
			//NSLog(@"setWochenplanForRaum: %d tag: %d objektbalken: %d tagbalkentyp: %d",derRaum, wochentag, objektbalken, TagbalkenTyp);
			}
			
			switch (TagbalkenTyp)
			{
				case 0: // Standard
				{
					ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					[ObjektTagplanbalken BalkenAnlegen];
					tempTitel=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objektname"];
					//tempTitel=@"-";
					//tempTitel=@"Brenner";
				}break; // case objektbalken =0
					
				case 1: // Mode
				{
					//		ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					//NSLog(@"setWochenplanForRaum: %d tag: %d objektbalken: %d tagbalkentyp: %d",derRaum, wochentag, objektbalken, TagbalkenTyp);
					ObjektTagplanbalken=(rModeTagplanbalken*)[[rModeTagplanbalken alloc]initWithFrame:Balkenfeld];
					//ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					[ObjektTagplanbalken BalkenAnlegen];
					tempTitel=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objektname"];
					
				}break; // case objektbalken=1
					
				case 2: // Servo
				{
					//		ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					
					ObjektTagplanbalken=[[rServoTagplanbalken alloc]initWithFrame:Balkenfeld];
					[ObjektTagplanbalken BalkenAnlegen];
               
					tempTitel=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objektname"];
				}break; // case objektbalken=2

            case 9: // Daten
				{
					//		ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					
					ObjektTagplanbalken=[[rDatenbalken alloc]initWithFrame:Balkenfeld];
					[ObjektTagplanbalken BalkenAnlegen];
               
					tempTitel=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objektname"];
				}break; // case objektbalken=2

				default:
				{
					ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					[ObjektTagplanbalken BalkenAnlegen];
					tempTitel=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objektname"];
					
				}
					
			}//switch Tagbalkentyp
			/*
			switch (derRaum)
			{
				case 0:
				case 2:
				{
					
					
				}break; //case derRaum=0
					
					
				default:
				{
					ObjektTagplanbalken=[[rTagplanbalken alloc]initWithFrame:Balkenfeld];
					[ObjektTagplanbalken BalkenAnlegen];
					tempTitel=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objektname"];
					
				}
			}//switch derRaum
			*/
			
			
			//NSLog(@"Tag: %d ",wochentag);
			
			//NSLog(@"Tag: %d Objekt: %d Titel: %@",wochentag,objektbalken,tempTitel);
			[ObjektTagplanbalken setTitel:tempTitel];
			[ObjektTagplanbalken setRaum: derRaum];
			[ObjektTagplanbalken setObjekt:[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"objekt"]];
			int originalTagplanIndex=[[aktivObjektArray objectAtIndex:objektbalken]intValue]; //originaler Index des Tagbalkens 
			int mark=100*derRaum +10*wochentag +originalTagplanIndex +WOCHENPLANOFFSET;
			[ObjektTagplanbalken setTag:mark];
			//if (derRaum==0)
				//NSLog(@"setWochenplanForRaum: %d originalTagplanIndex: %d",derRaum,mark );
				
			[ObjektTagplanbalken setWochentag:wochentag];
			
			//NSLog(@"setWochenplanForRaum: %d",derRaum);
			//NSLog(@"setWochenplanForRaum ObjektTagplanbalken: %@",[ObjektTagplanbalken description]);
//			[ObjektTagplanbalken retain];
			[self addSubview:ObjektTagplanbalken];
			//[Tagplan setTagplan:tempStundenArray forTag:6-wochentag];
			//	[Wochenplan addObject:Tagplan];
			[tempTagbalkenArray addObject:ObjektTagplanbalken];
			Balkenfeld.origin.y-=(Tagbalkenhoehe+4);
			
			//Stundenplan erzeugen
			NSMutableArray* tempStundenArray=[[NSMutableArray alloc]initWithCapacity:0];
			int l;
			//NSLog(@"Wochenplan setWochenplan vor Stundenplan");
			
			// Stundenplanarray des aktuellen Objekts
			NSArray* tempStundenplanArray=[[[aktivTagplanDicArray objectAtIndex:wochentag]objectAtIndex:objektbalken]objectForKey:@"stundenplanarray"];
			
         if ((derRaum==0) && (wochentag==0))
         {
            //NSLog(@"* setWochenplanForRaum Tag: %d objekt: %d tempStundenplanArray: %@",wochentag, objektbalken,[tempStundenplanArray description]);
         }
			
			for (l=0;l<24;l++)
			{
				NSMutableDictionary* tempStundenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				//[tempStundenDic setObject:[NSNumber numberWithInt:objektbalken%4] forKey:@"code"];
				[tempStundenDic setObject:[tempStundenplanArray objectAtIndex:l] forKey:@"code"];
				[tempStundenArray addObject:tempStundenDic];
			}
			//NSLog(@"setWochenplanForRaum * Tag: %d tempStundenArray: %@",wochentag,[tempStundenArray description]);
			
			[ObjektTagplanbalken setTagplan:tempStundenArray forTag:wochentag];
			
			//NSLog(@"setWochenplanForRaum nach setTagplan");
			if ((derRaum==0) && (wochentag==0) )
			{
				NSArray* tempStundenByteArray=[ObjektTagplanbalken StundenByteArray];
				//NSLog(@"Raum: %d Tag: %d objekt: %d StundenByteArray: %@",derRaum, wochentag, objektbalken, [tempStundenByteArray componentsJoinedByString:@" "]);
				int k;
            
            // Kontrolle
				NSString* StundenbyteString=[NSString string];
				for (k=0;k<[tempStundenByteArray count];k++)
				{
					
					NSString* ByteString=[NSString stringWithFormat:@"%02X ",[[tempStundenByteArray objectAtIndex:k]intValue]];
					//NSLog(@"ByteString: %@\t %d", ByteString, [[tempStundenByteArray objectAtIndex:k]intValue]);
					StundenbyteString=[StundenbyteString stringByAppendingString:ByteString] ;
				}
				//NSLog(@" Objekt: %d,  ByteString: %@ Titel: %@",objektbalken,  StundenbyteString,[ObjektTagplanbalken Titel]);
			}
			
		}//for objektbalken
      
		[TagplanArray addObject:tempTagbalkenArray];
		//NSLog(@"setWochenplanForRaum Tag: %d Tagplan %@",wochentag, [Tagplan description]);
		

		PlanFeld.origin.y=PlanfeldLevel-wochentag*(TagplanAbstand);
		//NSLog(@"PlanfeldLevel: %d PlanFeld.origin.y: %2.2f TagplanAbstand: %d",PlanfeldLevel,PlanFeld.origin.y,TagplanAbstand);
	}
	//NSLog(@"setWochenplanForRaum nach for wochentag");
	//NSLog(@"setWochenplanForRaum B");
	//NSLog(@"setWochenplanForRaum TagplanArray: %@",[[TagplanArray objectAtIndex:6] description]);
	return GeometrieArray;
}


- (void)changeCode:(int)derCode inStunde:(int)dieStunde vonFeld:(int)dasFeld inObjekt:(int)dasObjekt 
{
	//NSLog(@"Wochenplan changeCode: Objekt: %@",dasObjekt);
	int wochentag;
	
	for (wochentag=0;wochentag<2;wochentag++) // Daten in allen Tagbalken anpassen
	{
		//NSLog(@"Wochenplan changeCode: A");
		NSMutableArray* tempTagbalkenArray=(NSMutableArray*)[TagplanArray objectAtIndex:wochentag];
		//NSLog(@"Wochenplan changeCode: tempTagbalkenArray count: %d",[tempTagbalkenArray count]);
		//NSLog(@"[aktivObjektArray: %@",[aktivObjektArray description]);
		NSUInteger TagbalkenIndex=[aktivObjektArray indexOfObject:[NSNumber numberWithInt:dasObjekt]];
		//NSLog(@"TagbalkenIndex: %d",TagbalkenIndex);
		rTagplanbalken* tempTagbalken=[tempTagbalkenArray objectAtIndex:TagbalkenIndex];
		
		switch(dasFeld)
		{
			case 1: // Feld L
			case 2: // Feld R
			case 3:	// Feld U
			{
				//NSLog(@"Wochenplan changeCode Feld 1,2,3");
				//NSLog(@"aktivObjektArray: %@",[aktivObjektArray description]);
				
				[tempTagbalken setStundenarraywert:derCode vonStunde: dieStunde forKey:@"code"];
				
				//NSLog(@"Wochenplan changeCode B");
			}break;
			case 4://ALL-Taste
				//NSLog(@"Wochenplan changeCode Feld 4 start");
				//if ([[note userInfo]objectForKey:@"lastonarray"])
				{
					//NSLog(@"Wochenplan changeCode: lastonarray da count: %d",[[[note userInfo]objectForKey:@"lastonarray"] count]);
		//			[tempTagbalken setStundenArray:[[note userInfo]objectForKey:@"lastonarray"]  forKey:@"code"];
				}
				//NSLog(@"Wochenplan changeCode Feld 4 end");
				break;
				
		} //switch
		
	}
	
}

- (void)stundenplanzeigen:(NSArray*)stundenplan
{
   printf("wert: \t");
   for (int k=0;k<24;k++)
   {
      printf(" %d\t",[[stundenplan objectAtIndex:k]intValue]);
   }
   printf("\n");

}

- (void)ModifierAktion:(NSNotification*)note
{
	//NSLog(@"Wochenplan ModifierAktion: %@",[[note userInfo]description]);
	NSArray* Raumnamen=[NSArray arrayWithObjects:@"Heizung", @"Werkstatt", @"WoZi", @"Buero", @"Labor", @"OG1", @"OG2", @"Estrich", nil];
	
	
	if ([[[note userInfo]objectForKey:@"raum"]intValue]==Raum)
	{
	//NSLog(@"Wochenplan ModifierAktion: TagplanArray : %@",[TagplanArray description]);
	
	//NSLog(@"Wochenplan ModifierAktion: %@",[[note userInfo]description]);
	//NSLog(@"Raum stimmt: Raum: %d",Raum);
	int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
	int Stunde=[[[note userInfo]objectForKey:@"stunde"]intValue];
	int ON=[[[note userInfo]objectForKey:@"on"]intValue];
	int Feld=[[[note userInfo]objectForKey:@"feld"]intValue];
	int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
	//NSLog(@"aktivObjektArray: %@",[aktivObjektArray description]);

		int wochentag;
		//NSLog(@"Wochenplan ModifierAktion: Raum: %d Objekt: %d Feld: %d",Raum, Objekt,Feld );
		
		for (wochentag=0;wochentag<7;wochentag++) // Daten in allen Tagbalken anpassen
		{
			//NSLog(@"Wochenplan ModifierAktion: wochentag: %d",wochentag);
			NSMutableArray* tempTagbalkenArray=(NSMutableArray*)[TagplanArray objectAtIndex:wochentag];
			//NSLog(@"Wochenplan ModifierAktion: tempTagbalkenArray count: %d",[tempTagbalkenArray count]);

			NSUInteger TagbalkenIndex=[aktivObjektArray indexOfObject:[NSNumber numberWithInt:Objekt]];
			//NSLog(@"TagbalkenIndex: %d",TagbalkenIndex);
			rTagplanbalken* tempTagbalken=[tempTagbalkenArray objectAtIndex:TagbalkenIndex];
			//NSLog(@"tempTagbalken   Raum: %d", Raum);
			switch(Feld)
			{
				case 1: // Feld L
				case 2: // Feld R
				case 3:	// Feld U
				{
					//NSLog(@"Wochenplan ModifierAktion Feld 1,2,3");
					//NSLog(@"aktivObjektArray: %@",[aktivObjektArray description]);
					
					[tempTagbalken setStundenarraywert:ON vonStunde: Stunde forKey:@"code"];
					
					//NSLog(@"Wochenplan ModifierAktion B");
				}break;
				case 4://ALL-Taste
					//NSLog(@"Wochenplan ModifierAktion Feld 4 start");
					if ([[note userInfo]objectForKey:@"lastonarray"])
					{
						//NSLog(@"Wochenplan ModifierAktion: lastonarray da count: %d",[[[note userInfo]objectForKey:@"lastonarray"] count]);
						[tempTagbalken setStundenArray:[[note userInfo]objectForKey:@"lastonarray"]  forKey:@"code"];
					}
					//NSLog(@"Wochenplan ModifierAktion Feld 4 end");
					break;
					
			} //switch
			
		}
		
	}// if Raum
}



- (void)WriteWochenplanModifierAktion:(NSNotification*)note
{
	/*
	Notifiktion wird an jeden Wochenplan geschickt. Wenn der Raum stimmt, wird der Array mit allen Tagplaenen zusammengestellt
	und an den AVRClient geschickt mit Notifikation "WriteModifier"
	
	
	*/
	//NSLog(@"Wochenplan WriteWochenplanModifierAktion: raum: %d  %@",Raum,[[note userInfo]description]);
	NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];

	// Array mit den Stundenplaenen fuer das Objekt
	NSMutableArray* tempWriteArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSMutableDictionary* tempWriteDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
	
	if ([[[note userInfo]objectForKey:@"raum"]intValue]==Raum)
	{
		NSLog(@"Raum stimmt: Raum: %d %@",Raum,[[note userInfo]objectForKey:@"titel"]);
		//NSLog(@"Wochenplan WriteModifierAktion: TagplanArray : %@",[TagplanArray description]);
		
		//NSLog(@"Wochenplan WriteModifierAktion: %@",[[note userInfo]description]);
		
		int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
		Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
		[tempWriteDic setObject:[[note userInfo]objectForKey:@"objekt"]forKey:@"objekt"];
		[tempWriteDic setObject:[[note userInfo]objectForKey:@"raum"]forKey:@"raum"];
		[tempWriteDic setObject:[[note userInfo]objectForKey:@"titel"]forKey:@"titel"];
		//NSLog(@"aktivObjektArray: %@",[aktivObjektArray description]);
		
		int wochentag;
		NSLog(@"Wochenplan WriteModifierAktion: Raum: %d Objekt: %d",Raum, Objekt );
		
		for (wochentag=0;wochentag<7;wochentag++) // Daten aus allen Tagbalken des Objekts auslesen
		{
			//NSLog(@"Wochenplan ModifierAktion: wochentag: %d",wochentag);
			NSMutableArray* tempTagbalkenArray=(NSMutableArray*)[TagplanArray objectAtIndex:wochentag];
			//NSLog(@"Wochenplan WriteModifierAktion: tempTagbalkenArray count: %d",[tempTagbalkenArray count]);
			//NSLog(@"Wochenplan WriteModifierAktion: tempTagbalkenArray: %@",[tempTagbalkenArray description]);
			int k;
			int tagbalkenindex=0;
			
			// Tagbalken mitObjekt==Objekt suchen
			for (k=0;k<[tempTagbalkenArray count];k++)
			{
				if ([[tempTagbalkenArray objectAtIndex:k]Objekt]==Objekt)
				{
					tagbalkenindex=k;
				}
			}
			
			rTagplanbalken* tempTagbalken=[tempTagbalkenArray objectAtIndex:tagbalkenindex];
			
			//		NSLog(@"tempTagbalken   Raum: %d", Raum);
			if (tempTagbalken)
			{
				//			NSLog(@"AVR WriteModifierAktion tempTagplanArray");
				//NSMutableArray* tempStundenplanArray=[[tempTagplanArray objectAtIndex:Objekt]objectForKey:@"stundenplanarray"];
				NSMutableArray* tempStundenbyteArray=(NSMutableArray*)[tempTagbalken StundenByteArray];
				if (tempStundenbyteArray)
				{
					//tempStundenbyteArray auf 8 Elemente ergaenzen
					int i;
					for (i=[tempStundenbyteArray count];i<8;i++)
					{
						[tempStundenbyteArray addObject:[NSNumber numberWithInt:0]];
					}
					
					//NSLog(@"WriteModifierAktion tempStundenbyteArray : %@",[tempStundenbyteArray description]);
					
					//NSLog(@"tempStundenplanArray nach saveOK: %d",saveOK);
				}
				
				//NSLog(@"tempStundenbyteArray nach Ergaenzen: %@", [tempStundenbyteArray description]);
				[tempWriteArray addObject:tempStundenbyteArray];
				//NSLog(@"tempStundenbyteArray nach: %@", [tempStundenbyteArray description]);
	
			}
			
		}// for Wochentag
		//NSLog(@"tempWriteArray : %@", [tempWriteArray description]);
		
		[tempWriteDic setObject:tempWriteArray forKey:@"modifierstundenbytearray"];
		
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"WriteModifier" object:self userInfo:tempWriteDic];
		
		
	}// if Raum
}




- (void)drawRect:(NSRect)rect 
{
    // Drawing code here.
 
	
	
}

@end
