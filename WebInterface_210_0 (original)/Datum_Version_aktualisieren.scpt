FasdUAS 1.101.10   ��   ��    k             l   � ����  O    �  	  k   � 
 
     l   ��  ��     activate     �    a c t i v a t e      l   ��������  ��  ��        r        m       �      o      ���� 0 filecontents fileContents      r        4    �� 
�� 
alis  l  
  ����  l  
  ����  I  
 ��   
�� .earsffdralis        afdr   f   
    �� !��
�� 
rtyp ! m    ��
�� 
ctxt��  ��  ��  ��  ��    o      ���� 0 
homeordner     " # " l   �� $ %��   $ 0 *display dialog "homeordner: " & homeordner    % � & & T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r #  ' ( ' r     ) * ) n     + , + m    ��
�� 
ctnr , o    ���� 0 
homeordner   * o      ���� 0 homeordnerpfad   (  - . - l   �� / 0��   / 2 ,set main to file "datum.c" of homeordnerpfad    0 � 1 1 X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d .  2 3 2 r    " 4 5 4 b      6 7 6 l    8���� 8 c     9 : 9 o    ���� 0 homeordnerpfad   : m    ��
�� 
TEXT��  ��   7 m     ; ; � < <  d a t u m . c 5 o      ���� 0 filepfad   3  = > = l  # #�� ? @��   ? , &display dialog "filepfad: " & filepfad    @ � A A L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d >  B C B l  # #�� D E��   D ! tell application "TextEdit"    E � F F 6 t e l l   a p p l i c a t i o n   " T e x t E d i t " C  G H G I  # (������
�� .miscactv****      � ****��  ��   H  I J I r   ) 7 K L K l  ) 3 M���� M I  ) 3�� N O
�� .rdwropenshor       file N 4   ) -�� P
�� 
file P o   + ,���� 0 filepfad   O �� Q��
�� 
perm Q m   . /��
�� boovtrue��  ��  ��   L o      ���� 0 refnum RefNum J  R S R Q   8� T U V T k   ;� W W  X Y X r   ; D Z [ Z l  ; B \���� \ I  ; B�� ]��
�� .rdwrread****        **** ] o   ; >���� 0 refnum RefNum��  ��  ��   [ o      ���� 0 filecontents fileContents Y  ^ _ ^ l  E E��������  ��  ��   _  ` a ` l  E E�� b c��   b 7 1display dialog "inhalt: " & return & fileContents    c � d d b d i s p l a y   d i a l o g   " i n h a l t :   "   &   r e t u r n   &   f i l e C o n t e n t s a  e f e r   E O g h g n   E K i j i 4   F K�� k
�� 
cpar k m   I J����  j o   E F���� 0 filecontents fileContents h o      ���� 0 datum Datum f  l m l l  P P�� n o��   n &  display dialog "Datum: " & Datum    o � p p @ d i s p l a y   d i a l o g   " D a t u m :   "   &   D a t u m m  q r q r   P Y s t s I  P U������
�� .misccurdldt    ��� null��  ��   t o      ���� 	0 heute   r  u v u l  Z Z�� w x��   w &  display dialog "heute: " & heute    x � y y @ d i s p l a y   d i a l o g   " h e u t e :   "   &   h e u t e v  z { z r   Z e | } | n   Z a ~  ~ 1   ] a��
�� 
year  o   Z ]���� 	0 heute   } o      ���� 0 jahrtext   {  � � � r   f q � � � n   f m � � � m   i m��
�� 
mnth � o   f i���� 	0 heute   � o      ���� 0 	monattext   �  � � � l  r r�� � ���   � * $display dialog "monat: " & monattext    � � � � H d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t t e x t �  � � � r   r � � � � n   r � � � � 7  } ��� � �
�� 
ctxt � m   � ������� � m   � ������� � l  r } ����� � b   r } � � � m   r u � � � � �  0 � n   u | � � � 1   x |��
�� 
day  � o   u x���� 	0 heute  ��  ��   � o      ���� 0 tag   �  � � � l  � ��� � ���   � " display dialog "tag: " & tag    � � � � 8 d i s p l a y   d i a l o g   " t a g :   "   &   t a g �  � � � r   � � � � � J   � � � �  � � � m   � ���
�� 
jan  �  � � � m   � ���
�� 
feb  �  � � � m   � ���
�� 
mar  �  � � � l 	 � � ����� � m   � ���
�� 
apr ��  ��   �  � � � m   � ���
�� 
may  �  � � � m   � ���
�� 
jun  �  � � � m   � ���
�� 
jul  �  � � � m   � ���
�� 
aug  �  � � � l 	 � � ����� � m   � ���
�� 
sep ��  ��   �  � � � m   � ���
�� 
oct  �  � � � m   � ���
�� 
nov  �  ��� � m   � ���
�� 
dec ��   � o      ���� 0 monatsliste MonatsListe �  � � � Y   � � ��� � ��� � Z   � � � ����� � =   � � � � � o   � ����� 0 	monattext   � n   � � � � � 4   � ��� �
�� 
cobj � o   � ����� 0 i   � o   � ����� 0 monatsliste MonatsListe � k   � � � �  � � � r   � � � � � n   � � � � � 7  � ��� � �
�� 
ctxt � m   � ������� � m   � ������� � l  � � ����� � b   � � � � � m   � � � � � � �  0 � o   � ����� 0 i  ��  ��   � o      ���� 	0 monat   �  ��� � l  � � � � � �  S   � � � - ' wenn true, wird die Schleife verlassen    � � � � N   w e n n   t r u e ,   w i r d   d i e   S c h l e i f e   v e r l a s s e n��  ��  ��  �� 0 i   � m   � �����  � m   � ����� ��   �  � � � l  � ��� � ���   � &  display dialog "monat: " & monat    � � � � @ d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t �  � � � r   � � � � l 	 �
 ����� � l  �
 ����� � n  �
 � � � 7  �
�� � �
�� 
cha  � m  ����  � m  	����  � l  � � ����� � c   � � � � � o   � ����� 0 jahrtext   � m   � ���
�� 
ctxt��  ��  ��  ��  ��  ��   � o      ���� 0 jahr   �  � � � l �� � ���   � ? 9display dialog "jahr: " & jahr & " jahrtext: " & jahrtext    � � � � r d i s p l a y   d i a l o g   " j a h r :   "   &   j a h r   &   "   j a h r t e x t :   "   &   j a h r t e x t �  � � � r   � � � n   � � � m  �
� 
nmbr � n   � � � 2 �~
�~ 
cha  � o  �}�} 0 datum Datum � o      �|�| 0 l   �  � � � l �{ � ��{   � 1 +set neuesDatum to text -l thru -13 of Datum    � � � � V s e t   n e u e s D a t u m   t o   t e x t   - l   t h r u   - 1 3   o f   D a t u m �    l 2 r  2 n  . 7 ".�z	

�z 
ctxt	 m  &(�y�y 
 m  )-�x�x  o  "�w�w 0 datum Datum o      �v�v 0 
neuesdatum 
neuesDatum $  Anfang bis und mit Leerschlag    � <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g  l 33�u�u   2 ,display dialog "neuesDatum A: " & neuesDatum    � X d i s p l a y   d i a l o g   " n e u e s D a t u m   A :   "   &   n e u e s D a t u m  r  3V b  3R b  3N b  3J b  3F b  3B b  3>  b  3:!"! o  36�t�t 0 
neuesdatum 
neuesDatum" m  69## �$$  @ "  o  :=�s�s 0 tag   m  >A%% �&&  . o  BE�r�r 	0 monat   m  FI'' �((  . o  JM�q�q 0 jahrtext   m  NQ)) �**  " o      �p�p 0 
neuesdatum 
neuesDatum +,+ l WW�o-.�o  - 0 *display dialog "neuesDatum: " & neuesDatum   . �// T d i s p l a y   d i a l o g   " n e u e s D a t u m :   "   &   n e u e s D a t u m, 010 r  Wi232 b  We454 b  Wa676 n  W]898 4  X]�n:
�n 
cpar: m  [\�m�m 9 o  WX�l�l 0 filecontents fileContents7 o  ]`�k
�k 
ret 5 o  ad�j�j 0 
neuesdatum 
neuesDatum3 o      �i�i 0 	neuertext 	neuerText1 ;<; l jj�h=>�h  = 3 -set paragraph 2 of fileContents to neuesDatum   > �?? Z s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e s D a t u m< @A@ l jj�gBC�g  B 9 3display dialog "neues Datum: " & return & neuerText   C �DD f d i s p l a y   d i a l o g   " n e u e s   D a t u m :   "   &   r e t u r n   &   n e u e r T e x tA EFE I ju�fGH
�f .rdwrseofnull���     ****G o  jm�e�e 0 refnum RefNumH �dI�c
�d 
set2I m  pq�b�b  �c  F JKJ I v��aLM
�a .rdwrwritnull���     ****L o  vy�`�` 0 	neuertext 	neuerTextM �_N�^
�_ 
refnN o  |�]�] 0 refnum RefNum�^  K O�\O I ���[P�Z
�[ .rdwrclosnull���     ****P o  ���Y�Y 0 refnum RefNum�Z  �\   U R      �X�W�V
�X .ascrerr ****      � ****�W  �V   V I ���UQ�T
�U .rdwrclosnull���     ****Q o  ���S�S 0 refnum RefNum�T   S RSR l ���R�Q�P�R  �Q  �P  S TUT l ���OVW�O  V   Neue Version einsetzen   W �XX .   N e u e   V e r s i o n   e i n s e t z e nU YZY r  ��[\[ m  ��]] �^^  \ o      �N�N 0 filecontents fileContentsZ _`_ r  ��aba 4  ���Mc
�M 
alisc l ��d�L�Kd l ��e�J�Ie I ���Hfg
�H .earsffdralis        afdrf  f  ��g �Gh�F
�G 
rtyph m  ���E
�E 
ctxt�F  �J  �I  �L  �K  b o      �D�D 0 
homeordner  ` iji l ���Ckl�C  k 0 *display dialog "homeordner: " & homeordner   l �mm T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e rj non r  ��pqp n  ��rsr m  ���B
�B 
ctnrs o  ���A�A 0 
homeordner  q o      �@�@ 0 homeordnerpfad  o tut r  ��vwv n  ��xyx 1  ���?
�? 
pnamy o  ���>�> 0 homeordnerpfad  w o      �=�= 0 projektname Projektnameu z{z l ���<|}�<  | 2 ,display dialog "Projektname: " & Projektname   } �~~ X d i s p l a y   d i a l o g   " P r o j e k t n a m e :   "   &   P r o j e k t n a m e{ � r  ����� n ����� 1  ���;
�; 
txdl� 1  ���:
�: 
ascr� o      �9�9 0 olddels oldDels� ��� r  ����� m  ���� ���  _� n     ��� 1  ���8
�8 
txdl� 1  ���7
�7 
ascr� ��� l ���6�5�4�6  �5  �4  � ��� r  ����� n  ����� 2 ���3
�3 
citm� o  ���2�2 0 projektname Projektname� o      �1�1 0 zeilenliste Zeilenliste� ��� r  ����� n  ����� m  ���0
�0 
nmbr� o  ���/�/ 0 zeilenliste Zeilenliste� o      �.�. 0 	anzzeilen 	anzZeilen� ��� l ���-���-  � n hdisplay dialog "Zeilenliste: " & return & (Zeilenliste as list) & return & "Anzahl Zeilen: " & anzZeilen   � ��� � d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   ( Z e i l e n l i s t e   a s   l i s t )   &   r e t u r n   &   " A n z a h l   Z e i l e n :   "   &   a n z Z e i l e n� ��� l ���,�+�*�,  �+  �*  � ��� l ���)���)  � � �display dialog "Zeilenliste: " & return & item 1 of Zeilenliste & return & item 2 of Zeilenliste & return & item 3 of Zeilenliste & return & item 4 of Zeilenliste & return & item 5 of Zeilenliste   � ���� d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   i t e m   1   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   2   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   3   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   4   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   5   o f   Z e i l e n l i s t e� ��� r  ����� n  ����� 4  ���(�
�( 
cobj� l ����'�&� \  ����� o  ���%�% 0 	anzzeilen 	anzZeilen� m  ���$�$ �'  �&  � o  ���#�# 0 zeilenliste Zeilenliste� o      �"�" 0 version1 Version1� ��� r  ���� n  �	��� 4  	�!�
�! 
cobj� o  � �  0 	anzzeilen 	anzZeilen� o  ��� 0 zeilenliste Zeilenliste� o      �� 0 version2 Version2� ��� r  ��� o  �� 0 olddels oldDels� n     ��� 1  �
� 
txdl� 1  �
� 
ascr� ��� l ����  �  �  � ��� l ����  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r  #��� b  !��� l ���� c  ��� o  �� 0 homeordnerpfad  � m  �
� 
TEXT�  �  � m   �� ���  v e r s i o n . c� o      �� 0 filepfad  � ��� l $$����  � , &display dialog "filepfad: " & filepfad   � ��� L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d� ��� I $)���
� .miscactv****      � ****�  �  � ��� r  *8��� l *4���� I *4���
� .rdwropenshor       file� 4  *.�
�
�
 
file� o  ,-�	�	 0 filepfad  � ���
� 
perm� m  /0�
� boovtrue�  �  �  � o      �� 0 refnum RefNum� ��� Q  9����� k  <��� ��� r  <E��� l <C���� I <C���
� .rdwrread****        ****� o  <?� �  0 refnum RefNum�  �  �  � o      ���� 0 filecontents fileContents� ��� l FF������  � 7 1display dialog "inhalt: " & return & fileContents   � ��� b d i s p l a y   d i a l o g   " i n h a l t :   "   &   r e t u r n   &   f i l e C o n t e n t s� ��� l FF��������  ��  ��  � ��� r  FP��� n  FL��� 4  GL���
�� 
cpar� m  JK���� � o  FG���� 0 filecontents fileContents� o      ���� 0 alteversion  � ��� l QQ������  � . (display dialog "Version: " & alteversion   � ��� P d i s p l a y   d i a l o g   " V e r s i o n :   "   &   a l t e v e r s i o n� � � r  Q` n  Q\ m  X\��
�� 
nmbr n  QX 2 TX��
�� 
cha  o  QT���� 0 alteversion   o      ���� 0 l     l at	
	 r  at n  ap 7 dp��
�� 
ctxt m  hj����  m  ko����  o  ad���� 0 alteversion   o      ���� 0 neueversion neueVersion
 $  Anfang bis und mit Leerschlag    � <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g  l uu��������  ��  ��    r  u� b  u� b  u� b  u� b  u�  b  u�!"! b  u�#$# b  u%&% n  u{'(' 4  v{��)
�� 
cpar) m  yz���� ( o  uv���� 0 filecontents fileContents& o  {~��
�� 
ret $ o  ����� 0 neueversion neueVersion" m  ��** �++  @ "  o  ������ 0 version1 Version1 m  ��,, �--  . o  ������ 0 version2 Version2 m  ��.. �//  " o      ���� 0 	neuertext 	neuerText 010 l ����23��  2 4 .set paragraph 2 of fileContents to neueVersion   3 �44 \ s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e V e r s i o n1 565 I ����7��
�� .sysodlogaskr        TEXT7 b  ��898 b  ��:;: m  ��<< �==  n e u e   V e r s i o n :  ; o  ����
�� 
ret 9 o  ������ 0 	neuertext 	neuerText��  6 >?> I ����@A
�� .rdwrseofnull���     ****@ o  ������ 0 refnum RefNumA ��B��
�� 
set2B m  ������  ��  ? CDC I ����EF
�� .rdwrwritnull���     ****E o  ������ 0 	neuertext 	neuerTextF ��G��
�� 
refnG o  ������ 0 refnum RefNum��  D H��H I ����I��
�� .rdwrclosnull���     ****I o  ������ 0 refnum RefNum��  ��  � R      ������
�� .ascrerr ****      � ****��  ��  � k  ��JJ KLK l ����������  ��  ��  L M��M I ����N��
�� .rdwrclosnull���     ****N o  ������ 0 refnum RefNum��  ��  � O��O I ����P��
�� .aevtodocnull  �    alisP n  ��QRQ 4  ����S
�� 
fileS m  ��TT �UU , W e b I n t e r f a c e . x c o d e p r o jR o  ������ 0 homeordnerpfad  ��  ��   	 m     VV�                                                                                  MACS   alis    r  Macintosh HD               ŕ��H+     u
Finder.app                                                       v��R�u        ����  	                CoreServices    ŕt�      �Rve       u   1   0  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��    W��W l     ��������  ��  ��  ��       ��XY��  X ��
�� .aevtoappnull  �   � ****Y ��Z����[\��
�� .aevtoappnull  �   � ****Z k    �]]  ����  ��  ��  [ ���� 0 i  \ [V ������������������ ;������������������������������ ������������������������������������� �����������������#%')������~�}�|�{�z�y]�x�w�v�u�t��s�r�q�p�o��n�m�l*,.<�kT�j�� 0 filecontents fileContents
�� 
alis
�� 
rtyp
�� 
ctxt
�� .earsffdralis        afdr�� 0 
homeordner  
�� 
ctnr�� 0 homeordnerpfad  
�� 
TEXT�� 0 filepfad  
�� .miscactv****      � ****
�� 
file
�� 
perm
�� .rdwropenshor       file�� 0 refnum RefNum
�� .rdwrread****        ****
�� 
cpar�� 0 datum Datum
�� .misccurdldt    ��� null�� 	0 heute  
�� 
year�� 0 jahrtext  
�� 
mnth�� 0 	monattext  
�� 
day ������ 0 tag  
�� 
jan 
�� 
feb 
�� 
mar 
�� 
apr 
�� 
may 
�� 
jun 
�� 
jul 
�� 
aug 
�� 
sep 
�� 
oct 
�� 
nov 
�� 
dec �� �� 0 monatsliste MonatsListe
�� 
cobj�� 	0 monat  
�� 
cha �� �� 0 jahr  
�� 
nmbr�� 0 l  �� �� 0 
neuesdatum 
neuesDatum
�� 
ret �� 0 	neuertext 	neuerText
� 
set2
�~ .rdwrseofnull���     ****
�} 
refn
�| .rdwrwritnull���     ****
�{ .rdwrclosnull���     ****�z  �y  
�x 
pnam�w 0 projektname Projektname
�v 
ascr
�u 
txdl�t 0 olddels oldDels
�s 
citm�r 0 zeilenliste Zeilenliste�q 0 	anzzeilen 	anzZeilen�p 0 version1 Version1�o 0 version2 Version2�n 0 alteversion  �m �l 0 neueversion neueVersion
�k .sysodlogaskr        TEXT
�j .aevtodocnull  �    alis������E�O*�)��l /E�O��,E�O��&�%E�O*j O*��/�el E` OU_ j E�O�a l/E` O*j E` O_ a ,E` O_ a ,E` Oa _ a ,%[�\[Za \Zi2E` Oa a  a !a "a #a $a %a &a 'a (a )a *a +vE` ,O :ka +kh  _ _ ,a -�/  a .�%[�\[Za \Zi2E` /OY h[OY��O_ �&[a 0\[Zm\Za 12E` 2O_ a 0-a 3,E` 4O_ [�\[Zk\Za 52E` 6O_ 6a 7%_ %a 8%_ /%a 9%_ %a :%E` 6O�a k/_ ;%_ 6%E` <O_ a =jl >O_ <a ?_ l @O_ j AW X B C_ j AOa DE�O*�)��l /E�O��,E�O�a E,E` FO_ Ga H,E` IOa J_ Ga H,FO_ Fa K-E` LO_ La 3,E` MO_ La -_ Mk/E` NO_ La -_ M/E` OO_ I_ Ga H,FO��&a P%E�O*j O*��/�el E` O �_ j E�O�a l/E` QO_ Qa 0-a 3,E` 4O_ Q[�\[Zk\Za R2E` SO�a k/_ ;%_ S%a T%_ N%a U%_ O%a V%E` <Oa W_ ;%_ <%j XO_ a =jl >O_ <a ?_ l @O_ j AW X B C_ j AO��a Y/j ZU ascr  ��ޭ