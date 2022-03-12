%READ FIRST
%March 12, 2022  UCAR scalar mapping program writen in Matlab
%Please attribute Abeqas LLC, at abeqas.com for the current
%version   in house programming by Michael Wallace
%Welcome new programmers and scientists. Through GitHub, we can advance together, since my
%programming could be significantly improved.  Stay tuned for more development content
%no representations are made or implied.  Use at own risk!
%set trendflags.. non-Trend = 2 or any number other than 1 Trend = 1
TrendFlag= 2; % flag to display trend or correlation products if ==1
% ncdf reading%if unable to find original .nc files, contact mwa@abeqas.com
%ERAI.DIVSK.1979-2014, ERAI.EP.1979-2011
%**********ERAI.KEDIV.1979-2014,  ERAI.K.1979-2014, ERAI.ITEN.1979-2014
%^^^ERAI.MRES.1979-2014doesn'twork, ERAI.LETEN.1979-2014, ERAI.KTEN.1979-2014
%@@@ERAI.PS.1979-2014, ERAI.PHISTEN.1979-2014, ERAI.PHIS.1979-2014
%####ERAI.Q1QF.1979-2014, ERAI.Q.1979-2014, ERAI.PSTEN.1979-2014,
%****ERAI.TETEN.1979-2014, ERAI.TE.1979-2014,ERAI.QTEN.1979-2014
%&&&&& next trying these ERAI.V.1979-2014, ERAI.U.1979-2014
%&&&&&&&&&&&&& next trying these ERAI.UC.1979-2014,ERAI.VC.1979-2014
%next tried these also good%ERAI.VC.1979-2014,ERAI.T.1979-2014
%************first tried these ERAI.LEDIV.1979-2014, ERAI.Z.1979-2014, ERAI.TEDIV.1979 all successes
%@@@@@@CHANGE HERE BELOW to set up months to read     @@@@@@@@@@@@@@
%set up for rcount.
%noting month 374, low extreme for Artic Oscillation
%13-72 is 5yta ending 'Jan1 1985',%73-132 is 5yta ending 'Jan1 1990'
%133-192 is 5yta ending 'Jan 1 1995,%193-252 is 5yta ending 'Jan1 2000'
%253-312 is 5yta ending 'Jan 1 2005',%313-372 is 5yta ending 'Jan 1 2010'
%373-432 is 5yta ending 'Jan 1 2015'
%49-108 is 5yta ending 'Jan 1 1988' %253-312 is 5yta ending 'Jan1 2005'
%361-420 is 5yta ending 'Jan 1 2014'  %313-372 is 5yta ending 'Jan1 2009'
%361-372 for '2010'   373-384 for '2011'
%373-432 is 5yta ending 'Jan 1 2015'
%409-411 first three months of 2013     %august 1999 is 248
%305 may 2004 high tornado month 329 low action  365 also
%277-288 for year 2002  1985 = 73-84
%1996=205thru216, 1997=, 1998=, 1999=, 2000=, 2001=, 2002=, 2003=, 
%2004=301-312,
%2005=313-324, 2006=, 2007=, 2008=, 2009=, 2010=, 2011=, 2012=
rbeg = 7;%13 to 72 for 1985 5 yta %253-312 is for 2005yta 230 el nino  la nina 122
rend = 12;  %432 for full series
%rend = 72;
rspan = 1;
%@@@@@@CHANGE HERE BELOW and below in LEDIVData ncread line@@@@@@@@@@@@@@
myChoice = 'T'; %select from the above parameter options including LEDIV, T, Z, EP mainly
%@@@@@@CHANGE HERE ABOVE and below in LEDIVData ncread line@@@@@@@@@@@@@@

myERAIparam= strcat('ERAI.',myChoice,'.1979-2014.nc');
ncid = netcdf.open(myERAIparam,'NC_NOWRITE');
[ndims,nvars,natts,unlimdimID]= netcdf.inq(ncid);
%ginfo = ncinfo(ERAI.TEDIV.1979-2014.nc');%just saved few txt
myncdisp = strcat('ERAI.',myChoice,'.1979-2014.nc');
ncdisp(myncdisp);
%NOTE, to save time I don't change the temp array name from LEDIV
mylevdivdata = strcat('ERAI.',myChoice,'.1979-2014.nc')

%@@@@@@@@@CHANGE HERE below and above in myChoice line @@@@@@@@@@@@@@@@@@
LEDIVData = ncread(mylevdivdata,'T');%STILL MUST CHANGE last entry by hand, in quotes
%@@@@@@@@@CHANGE HERE above and above in myChoice line @@@@@@@@@@@@@@@@@@
%now reading in a vector to test correlations against
PathCorstring = strcat('D:\2020UCARresearch\'); 
%%%%% reading in the 432 row vector for correlations. Sometimes this file
%%%%% is produced by "recursively" first running Matlab to get that vector
%%%%% in the first place, as I did for Animas  but other times derived from
%%%%% USGS monthly streamflow, or from Solar.
%%%  AlbaV.csv, SSNcase#.csv  maybe soon try MaunaLoaCO2..
FileACor = 'SSNcase5'; %enter file prefix here only 'myTest'
FileBCor = '.csv';
FileCorstring = strcat(FileACor,FileBCor);
NameCorstring = strcat(PathCorstring,FileCorstring);
TestCor = importdata(FileCorstring,',');
%yearCor = TestCor(:,1);
VelocitySiteRecord = TestCor(:,1); %@@@@@@@here is my target velocity vector to correlate against try against EP
%@@@@@@@@@CHANGE HERE below for OUTPUT specification which relates
%FileAmean = 'ERAI_myZ_Annual_2014'    %enter file prefix here only
%FileAmean = 'ERAI_EP';    %enter file prefix here only such as ERAI_EPcontour, ERAI_EPsurf, ERAI Zcontour, etc.
FileAmean = 'ERAI_';    %enter file prefix here only such as ERAI_EPcontour, ERAI_EPsurf, ERAI Zcontour, etc.
% final manual entry, change prefix to ..MeanMonthly_' as desired ++++++****************
%@@@@@@@@@CHANGE HERE above


%LEDIVData = ncread('ERAI.Z.1979-2014.nc','Z'); %RECENTLY the best
% as LEDIV was my first successful run ++++++****************
%LEDIVData = ncread('ERAI.Z.1979-2014.nc','Z');;%just saved few txt
netcdf.close(ncid);
%ClipSize1 = LEDIVData(:1);;%just saved few txt
SizeOfLEDIVData = size(LEDIVData);
[Longitude, Latitude, monthYear,] = size(LEDIVData);
%test=LEDIVData(:,1:256);
%test=LEDIVData(:,:);
%testA = test'; %inverts the matrix test
%set up all figures for white background
whitebg('white')
set(gcf,'Color','white')
%Pathstring2 = 'C:\Users\Michael Wallace\Documents\UNM_NSMS\HarjitResearch\2016paper\UcarDownloads\UCARfigures\'
%just saved few pathstring txt  Geopotential Height\'  or
%or EvapMinusPrecip\'  or Temperature\'  or LEDIV\'
%old path for Toshiba:  Pathstring2 = 'C:\Users\Michael Wallace\Documents\UNM_NSMS\Dissertation Research\2016paper\TermProject\Temperature\'; %final manual entry, change prefix to ..MeanMonthly_' as desired ++++++****************EvapMinusPrecip\'
%tf = myChoice == 'Z'
%Pathstring2 = strcat('C:\Users\csimW\Documents\2020UCARresearch\UCARassets\',myChoice,'\'); %final manual entry, change prefix to ..MeanMonthly_' as desired ++++++****************EvapMinusPrecip\'
Pathstring2 = strcat('D:\2020UCARresearch\UCARassets\',myChoice,'\'); %final manual entry, change prefix to ..MeanMonthly_' as desired ++++++****************EvapMinusPrecip\'

%Pathstring2 = 'C:\Users\csimW\Documents\UNM_NSMS\Dissertation Research\2016paper\TermProject\Temperature\'; %final manual entry, change prefix to ..MeanMonthly_' as desired ++++++****************EvapMinusPrecip\'
%C:\Users\Michael Wallace\Documents\UNM_NSMS\Dissertation Research\2016paper\TermProject\LEDIV final manual entery, change prefix to ..MeanMonthly_' as desired ++++++****************

%below is original but above is a means to produce the mean of all
%manual mod of TMonthly_ would be required for each UCAR asset.
FileA = 'EPMonthly_';   %enter file prefix here only
FileB = '.fig';
FileC = '.png';
%
%nrows changes for each dataset imported
nsets = monthYear;  %432 sets from file covering 432 months
nlongrows = Longitude; %512 rows from file for longitude
nlatcols = Latitude;% 256 columns from file for each latitude set
ncols = nsets*nlatcols;
nrows = nlongrows;
%Manual Setting REQUIRED VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%NOTE..coarsening algorithm is not complete. must correct for northern and
%eastern bias due to the crude approach I adopt for now. NOTE NOTE NOTE
GridScale = 1;% set to 1 for original fine grid, 2 for coarse grid
if GridScale == 2
    degPercolumn = 2.8125;  %use for coarser grid
    rowsperSet = 64; %use for coarse grid
elseif GridScale == 3 %check, seems to bias to east
    degPercolumn = 5.625;  %use for coarser grid
    rowsperSet = 32; %use for coarse grid
elseif GridScale == 4
    degPercolumn = .25;  %use for AVISO grid
    rowsperSet = 720; %use for AVISO grid
else
    degPercolumn = 0.703125; %use for finer original grid
    rowsperSet = 256; %use for fine grid
end
%Manual Setting REQUIRED ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
tempmin = 1e8;
tempmax = -1e7; 
LatScale = [-89.6484375:0.703125:89.6484375]';%for lat based plots
%LongScale = [0.0:0.703125:359.5];%legacy not used

 LatentH = zeros(nlongrows, nlatcols);
 meanLatH = zeros(nlongrows, nlatcols);%meanLatH builds an average value for ultimate plotting
 %if not interested in the average over the period of interest, comment out
 %where indicated lower down in program
 meanLatHTemp = meanLatH;

%set up for developing arrays of values at target locations for copying and
%pasting into excel later if desired
%PolarStripCalc = zeros(nsets,Longitude);
MonthArray = zeros(nsets,1);
NMCalc = zeros(nsets,1);
NMBox = zeros([9,8]);
 NMboxlongspan = 356; NMboxlatspan = 172; %currently for TWWPBox only
MyCorArray = zeros(nlongrows,nlatcols);

MyTrendArray = zeros(512,256);

NGRIPCalc = zeros([nsets,1]);
SummitCalc = zeros([nsets,1]);
SouthPoleCalc = zeros([nsets,1]);
VostokCalc = zeros([nsets,1]);
McMurdoCalc= zeros([nsets,1]);
LawDomeCalc = zeros([nsets,1]);
KamchatCalc = zeros([nsets,1]);
NuukCalc = zeros([nsets,1]);
BarrowCalc = zeros([nsets,1]);
FortCalc = zeros([nsets,1]);
AlbCalc = zeros([nsets,1]);
AukCalc = zeros([nsets,1]);
Seoul =  zeros([nsets,1]);
Wuhan =  zeros([nsets,1]);
Singapore =  zeros([nsets,1]);
GuamCalc = zeros([nsets,1]);
HwiCalc = zeros(nsets,1);
JacobsCalc = zeros(nsets,1);
NWGreenCalc = zeros(nsets,1);
NEGreenCalc = zeros(nsets,1);
SEGreenCalc = zeros(nsets,1);
%AnimasCalc = zeros([nsets,1]);
twwpCalc = zeros(nsets,1);
urgwCalc = zeros(nsets,1);
BoulderCalc = zeros(nsets,1);
globalCalc = zeros([nsets,1]);
laVLCalc = zeros([nsets,1]);
bullseye1 =  zeros([nsets,1]);
Charleston =  zeros([nsets,1]);
ConstantWetSpot = zeros([nsets,1]);
TahitiWetSpot =  zeros([nsets,1]);
GNPSpot = zeros([nsets,1]);
PyrnSpot = zeros([nsets,1]);
ITCZInflowsCapture82degLong = zeros([nsets,1]);
TWWPBox = zeros([65,15]);
TWBox = zeros([nsets,1]);
   boxlongspan = 191; boxlatspan = 121; %currently for TWWPBox only
   KamStripCalc = zeros(nsets,Latitude);
HwiBox = zeros([50,22]);
   Hwiboxlongspan = 262; Hwiboxlatspan = 146; %currently for TWWPBox only



monthVector = (rbeg:rspan:rend );
monthVectorT = monthVector';
mymonthsize = size(monthVectorT,1);
MyCorBox = zeros(mymonthsize,512,256);
MyLatTrend = zeros(256);
AnimasCalc = zeros([mymonthsize,1]);
%rspan = 1;
%416 TO 421=july2013 thru jan2014
%July 5yta rspan 12, 1980 through 1984 is 19 - 67. 1985 through 1989 is 79 - 127,
%July 5yta rspan 12, 1990 through 1994 is 139 -187. 1995 through 2000 is 199 - 247 ,
%July 5yta rspan 12, 2000 through 2004 is 259 - 307. 2005 through 2009 is 319 - 367,
%July 5yta rspan 12, 2010 through 2014 is 379 - 427.
%January 5yta rspan 12, 1980 through 1984 is 13 - 61. 1985 through 1989 is 73 - 121,
%January 5yta rspan 12, 1990 through 1994 is 133 - 181. 1995 through 2000 is 193 - 241 ,
%January 5yta rspan 12, 2000 through 2004 is 253 - 301. 2005 through 2009 is 313 - 361,
%January 5yta rspan 12, 2010 through 2014 is 373 - 421.
%61 to 120 is 5yta or 60 month avg ending Dec 31 1988.
%START MAIN LOOP ***********************************************
myBegYear = (23748 + rbeg)/12;
myEndYear = (23748 + rend)/12;
     myglobalMax = -100000000.0;
     myglobalMin = 100000000.0;
 kount = 0;
 for r = rbeg:rspan:rend 
     myYear=(23748+r)/12; %24033 starts off AIRS
     myMonth = r;
    % myglobalMax = -100000000.0;
     %myglobalMin = 100000000.0;

  hold off;
    kount = kount +1;
    begMonth = num2str(kount);
    inputKount = 0;
  myTrendXArray(kount)=kount*rspan;
  myTrendX = myTrendXArray';
        startcol = ((r-1) * nlatcols)+1;%trying this
        endcol  = (startcol + nlatcols)-1;%not used!
    
    for rr = 1:nlongrows %loop through rows, which are longitude
            innerK=0;
            rback=rr-1;%not used
           
          for rrr = 1:nlatcols  %cols are latitude
            outerK = startcol + innerK;
            innerK = innerK + 1;
            LatentH(rr,rrr)= LEDIVData(rr,outerK);
            % first setting up for capturing mins and maxes
             if LatentH(rr,rrr) < myglobalMin % & LatentH(rr,rrr) ~= 0
               myglobalMin = LatentH(rr,rrr);
             end
             if LatentH(rr,rrr) > myglobalMax % & LatentH(rr,rrr) ~= 0
              myglobalMax = LatentH(rr,rrr);
             end
            % next setting up for matrix indexing and captures 
             if kount == 1
              meanLatH(rr,rrr)= LatentH(rr,rrr);
              meanLatHTemp (rr,rrr)= meanLatH(rr,rrr);
             end
             if kount > 1
             meanLatH(rr,rrr)= (LatentH(rr,rrr)+ meanLatHTemp(rr,rrr));
             meanLatHTemp(rr,rrr)=meanLatH(rr,rrr);
             end
            % next setting up monitor points for drilling through time 
             %
            if rr == 452 && rrr == 236
                  NGRIPCalc(kount) = LatentH(rr,rrr);%antarct
            end
            if rr == 457 && rrr == 232
                  SummitCalc(kount) = LatentH(rr,rrr);%antarct
            end
            if rr == 1 && rrr == 1
                  SouthPoleCalc(kount) = LatentH(rr,rrr);%antarct
            end
            if rr == 152 && rrr == 17
                  VostokCalc(kount) = LatentH(rr,rrr);%antarct 
            end
            %older vostok probably incorrect so see above if rr == 152 && rrr == 16
             %     VostokCalc(kount) = LatentH(rr,rrr);%antarct high trend
            %end
            if rr == 237 && rrr == 18
                  McMurdoCalc(kount) = LatentH(rr,rrr);%antarct high trend
            end
      
             if rr == 160 && rrr == 33
                  LawDomeCalc(kount) = LatentH(rr,rrr);%antarct high trend
             end
            if rr == 438 && rrr == 220
                  NuukCalc(kount) = LatentH(rr,rrr);%Barrow AK
            end
            if rr == 289 && rrr == 230
                  BarrowCalc(kount) = LatentH(rr,rrr);%Barrow AK
            end  
            if rr == 245 && rrr == 237
                  KamchatCalc(kount) = LatentH(rr,rrr);%KamchatkaSwirl
                  myKamO(kount) = KamchatCalc(kount);
            end  
            if rr == 249 && rrr == 76
                  AukCalc(kount) = LatentH(rr,rrr);%Aukland, NZ
            end
            if rr == 457 && rrr == 123
                  FortCalc(kount) = LatentH(rr,rrr);%Fortaleza, Brazil
            end
            if rr == 360 && rrr == 179
                  AlbCalc(kount) = LatentH(rr,rrr);%Albuquerque, NM
            end
              if rr == 181 && rrr == 182
                 SeoulCalc (kount)=LatentH(rr,rrr);%using Seoul loc
              end
             if rr == 163 && rrr == 172
                 WuhanCalc (kount)=LatentH(rr,rrr);%using Wuhan loc
             end
              if rr == 148 && rrr == 131
                 SingaporeCalc (kount)=LatentH(rr,rrr);%using Singapore loc
              end            
             if rr == 206 && rrr == 148
                 GuamCalc (kount)=LatentH(rr,rrr);%using Guam loc
             end  
             if rr == 438 && rrr == 225
                 JacobsCalc (kount)=LatentH(rr,rrr);%using glacier loc
             end
              if rr == 432 && rrr == 240
                 NWGreenCalc (kount)=LatentH(rr,rrr);%using NWGreenland loc
              end
              if rr == 467 && rrr == 236
                 NEGreenCalc (kount)=LatentH(rr,rrr);%using NWGreenland loc
              end
              if rr == 456 && rrr == 223
                 SEGreenCalc (kount)=LatentH(rr,rrr);%using NWGreenland loc
              end      
              if rr == 359 && rrr == 182
                 AnimasCalc (kount)=LatentH(rr,rrr);%using Silverton loc
             end
             if rr == 224 && rrr == 129
                 twwpCalc (kount)=LatentH(rr,rrr);
             end
             if rr == 362 && rrr == 185
                BoulderCalc (kount)=LatentH(rr,rrr);
             end
             if rr == 360 && rrr == 179%this is Albuquerque and called that more clearly for vectors
                 urgwCalc (kount)=LatentH(rr,rrr);
             end
             if rr == 55 && rrr == 39
                 bullseye1(kount)=LatentH(rr,rrr);
             end
             if rr == 299 && rrr == 171
                 laVLCalc(kount)=LatentH(rr,rrr);%laVLCalc
             end
            if rr == 398 && rrr == 175
                 Charleston(kount)=LatentH(rr,rrr);
            end
            if rr == 293 && rrr == 157 %the HWS
                 ConstantWetSpot(kount)=LatentH(rr,rrr);
            end
            if rr == 293 && rrr == 104 %tahiti
                 TahitiWetSpot(kount)=LatentH(rr,rrr);
            end
            if rr == 350 && rrr == 197 %Glacier National Park
                 GNPSpot(kount)=LatentH(rr,rrr);
            end
            
            if rr == 511 && rrr == 191 %Glacier National Park
                 PyrnSpot(kount)=LatentH(rr,rrr);
            end
            
            
             %if rr == 82 && rrr >= 100 && rrr <= 171%leads to the 59 col array with rr rows
             %          inputKount = inputKount + 1;
              %        ITCZInflowsCapture82degLong(kount,inputKount)=LatentH(rr,rrr);
             %end
             
          end % end of rrr loop which covers the 512 latitude indexes *********
     
    end  % end of rr loop which covers the 256 longitude indexes **************
    
      %calculate a global mean for each month
                   mytest = mean(LatentH); 
                   mytest2 = mean(mytest);%this 2 step works for mean
                   globalCalc(r) = mytest2;%when done, copy this from Variables
                   

   %calculate average for various boxes, first the TWWP footprint

         for rr = 192:256 %loop through rows, which are longitude
          longbox = rr - boxlongspan;
            %innerK=0;
            %rback=rr-1;
           for rrr = 122:136 %loop through cols which are latitude
            latbox = rrr - boxlatspan;
            TWWPBox(longbox,latbox)= LatentH(rr,rrr);
           end
         end % end of dual loop to define the TWWPBox
   
   %Second, the Hawaii Curl Study Area of my interest
        for rr = 263:313 %loop through rows, which are longitude
         longbox = rr - Hwiboxlongspan;
          %innerK=0;
          %rback=rr-1;
         for rrr = 147:168 %loop through cols which are latitude
          latbox = rrr - Hwiboxlatspan;
          HwiBox(longbox,latbox)= LatentH(rr,rrr);
             %MyCorBox(r,longbox,latbox)= LatentH(rr,rrr);
         end
        end  % end of dual loop to define the Curl box, which is only a test
        
   %Second, MyCorBox  for making correlation maps
        for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude
             %MyCorBox(r,rr,rrr)= LatentH(rr,rrr);
             MyCorBox(kount,rr,rrr)= LatentH(rr,rrr);
         end
        end  % end of dual loop to define the correlation box
        
    %Third, the North Polar strip Study Area of my interest
        for rr = 1:Longitude %loop through rows, which are longitude
         %longbox = rr - Hwiboxlongspan;
          %innerK=0;
          %rback=rr-1;
          PolarStripCalc(kount,rr)= LatentH(rr,242);
        end  % end of dual loop to define the polar strip, which is only a test
 
    %Fourth, the New Mexico Study Area of my interest
    
        for rr = 357:365 %loop through rows, which are longitude
            longbox = rr - NMboxlongspan;
             for rrr = 173:180 %loop through cols which are latitude
              latbox = rrr - NMboxlatspan;
              NMBox(longbox,latbox)= LatentH(rr,rrr);
         %longbox = rr - Hwiboxlongspan;
          %innerK=0;
          %rback=rr-1;
  
             end
        end  % end of dual loop to define the polar strip, which is only a test
        
            for rrr = 1:Latitude %loop through cols, which are latitude
                 KamStripCalc(kount,rrr)= LatentH(245,rrr);
            end
        
        
   myNM = mean(NMBox);
    mmyNMmean = mean(myNM);
    NMCalc(kount)= mmyNMmean; %works makes time series of NM for any param
   mymean = mean(TWWPBox);
   mmymean = mean(mymean);
   TWBox(r) = mmymean; 
    %window and paste into excel for plotting etc.             
    %result(r) = LEDIVData(kount);
    %test = LEDIVData(:,startcol:endcol);%illegal.  must assign actual #s
                                         %instead of startcol and endcol\
   %accordingly, must build each matrix the loop way see examples below
   
   %end
   %testA = LatentH';%only on for multiplot
   %this worked and I made 432 plots.  now I turn off plot for other data
   %trying to make a mean plot here
   %meanLatH=meanLatH/r;

   %divide meanLatH by kount
   end  % end of month loop if all I want is an average of the selected time span
   %*********************************************************************
 %
   %next making the time series arrays for correlation work.
   %SSNs are all SSNcase#.csv, so far cases 1,2,3,4,5,6,7
   load SSNcase5.csv % load solar for cross corr
      load ArcticSepIce.csv % load ice for cross corr
   %for New Mexico calcs
   
       NMCalc(kount)= mmyNMmean;% is this redundant now?
       MyCorBoxSc= MyCorBox + 1.; % 300;
     % noting above addition of 10. so polyfit can run on all positive
     % numbers for EP case
     % {    
     %remember this "r" must follow original r loop above
 if TrendFlag == 1
 for rr = 1:512 %loop through rows, which are longitude
    % myprogress = rr
   for rrr = 1:256 %loop through cols which are latitude 
        p=polyfit(monthVectorT,MyCorBox(:,rr,rrr),1); 
        MyTrendArray(rr,rrr) = p(1,1); 
    end
  end  % end of dual loop for corr and trend outputs
        TrendArray=MyTrendArray';
        MyLatTrend = mean(TrendArray,2); %to get the av trend vs latitude plot
end %end of TrendFlag test

        colormap Jet;%Bone,Jet
        %}
%{
        %trying to average for each year.. not working
  for yyear = 1:36
        krk= 0;
   for mmonth = 1:12
        krk=krk +1;
      for rr = 1:512;
    for rrr = 1:256 %loop through cols which are latitude 
       mmytemp(mmonth,rrr) = mean(MyCorBox(mmonth,:,rrr));
      end%
     end%
    end%
        thismean=mmytemp/krk;
 %}

%tried and failed below though, I think, have to revisit because correlation
%part DOES WORK
%next, the correlation and Trend arrays  must now have more than two months
   %{
   for r = 1:432
   
%if rspan > 1
        for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude 
             %trying twwpCalc and AnimasCalc, AlbCalc
             %trying SSNcase1 next  MUST update number at end each time****
         %USE THIS!! MyCorSet = corrcoef(SSNcase5, MyCorBox(1:nsets,rr,rrr));
         %USE THIS!!MyCorArray(rr,rrr) = MyCorSet(1,2);
    %can also use  
%    MyCorSet = corrcoef(AnimasCalc, MyCorBox(1:nsets,rr,rrr));
  %   MyCorSet = corrcoef(AnimasCalc, MyCorBox(:,rr,rrr));
    %last best for its purpose MyCorSet = corrcoef(ArcticSepIce, MyCorBox(:,rr,rrr));
   % MyCorArray(rr,rrr) = MyCorSet(1,2);
    %FortCalc,VelocitySiteRecord
    %STARSTARSTARdec2020      
    %MyCorSet = corrcoef(VelocitySiteRecord, MyCorBox(:,rr,rrr));
    %bad MyCorSet = corrcoef(AnimasCalc(r), LatentH(rr,rrr));
        % MyCorArray(rr,rrr) = corrcoef(AnimasCalc (r), LatentH(rr,rrr));         
         p=polyfit(monthVectorT,MyCorBox(:,rr,rrr),1); 
         MyTrendArray(rr,rrr) = p(1,1);

         end
        end  % end of dual loop for corr and trend outputs
%end
        TrendArray=MyTrendArray';
        colormap Jet;%Bone,Jet
   end  %done with time series array construction
   %}
 %clear LEDIVData; % note this is temporary comment for multiplotting w/out
 %averaging.  need to clarify!!  when cleared, facilitates multiple files
 %work without choking the memory capacity
   %next three lines:  coarsening grid 
%{june2017
   meanLatH=meanLatHTemp/kount;  %remember this is for mean along with next line
   %NOTE meanlatH' is the CRUCIAL PRODUCT and only is temp comment out
   %%%%%%this is the one   %%%%%%%
%STARSTARSTARdec2020   Change testA as needed to plot primary OR correl
  testA = meanLatH';% here for primary map
    trythis=mean(testA,2); %for a chart of avg value for each latitude via LatScale
  %plot(LatScale,trythis);%copy and paste into command window to make chart
   %testA = MyCorArray';% here for correlation array plot, rspan must be >1
   if TrendFlag == 1
    testA = TrendArray;% here for trend array plot
   end %end of TrendFlag test
   
   
   %  To contour, must build a grid of values, based on the grid scaling
  %  assigned previously
  if GridScale == 2
   GriDgi = 4;
  elseif GridScale == 3
   GriDgi = 8;
     elseif GridScale == 4
   GriDgi = 1.5;
  else
   GriDgi = 1;
  end
  %Develop the original array of values into the new grid for contouring
  [Xq,Yq] = ndgrid(1:GriDgi:256,1:GriDgi:512);%set to new coarser grid or to orig if desired
  %[Xq,Yq] = ndgrid(1:4:256,1:4:512);%set to new coarser grid or to orig if desired
  [X,Y] = ndgrid(1:1:256,1:1:512);%MUST be set to original grid
  %  [Xq,Yq] = ndgrid(0:4:256,0:4:512);%doesn't work with this setting
    F = griddedInterpolant(X, Y, testA, 'linear');%this creates the master grid for interpolating
    Vq = F(Xq,Yq);  %this redistributes values from orig grid to a different grid
    negVq = flipud(Vq);
    %ITCZ = Vq(28:36,48:64);
    
  
    %
 %&&&&&&&& START CONTOURING FEATURES &&&&&&&&&&&&
     %the globalMin,Max can be queried for limits to assign for contours
     %for the final set used.  but I've already calculated the min and max
     %for all sets within the main loop
      globalMin = min(Vq);
      globalMax = max(Vq);
       gglobalMin = min(globalMin);
       gglobalMax = max(globalMax);
     %the cRangeEP values, see the actual "contourf" command above
      PolarAverageT = mean(PolarStripCalc,2);
      
 %cRangeEP = [5.6e7:2000000:8.e7];%full range for Z  25 divisions
        %partial range for Z surface FOR PAPER   
        %cRangeEP = [7.7e7:2000000:7.86e7];
        %cRangeEP = [-.000600:.00002:.00003];% full rangefor EP        
 %cRangeEP = [-.000100:.00002:.00004];%BEST for EP
 %cRangeEP = [1000000 : 100000 : 3000000.]; %BEST for reg temmperature
  %cRangeEP = [-1.: 0.02 : 1.]; %BEST for correls to twwp
        %cRangeEP = [6.1 : .05 : 6.5];%best for log temperature
 %cRangeEP = [-250: 50. : 250]; %BEST for LEDIV
        %cRangeEP = [-900 : 50. : 400]; %fullest for LEDIV
        
     % mydiv = (gglobalMax - gglobalMin)/30; %********generic default range slicing
       %cRangeEP = [gglobalMin : mydiv : gglobalMax]; %********generic default range
%cRangeEP = [-.0000002:0.00000002:.0000002];
 % image (Vq);
 %next three important to original and recent
  %%%%%    
  pcolor (Vq); %the best most frequently used by me%%%%%%
 %%%%%%    
 shading flat; %interp;% 
%%%%%%%    colormap (flipud(cool));  %BEST for EP Surface and really for contours
%colormap Winter; %Jet Hot Winter Bone Cool %The MASTER colorbar setting
    %colormap(flipud(jet)) %reverse color scheme remember now lower case
    %note Hot best for the specialized Z itcz surface FOR PAPER
  %colormap ((winter+white)/2);%Jet Hot Winter Bone %The MASTER colorbar setting
  colorbar;  % for the color legend
if TrendFlag == 2
%turn below off if plotting the trend
% {
tf = strcmp(myChoice,'Z');
%pcolor (Vq); %the best most frequently used by me   
   
if tf==1
  cRangeEP = [6.e7:2000000:8.e7];%full range for Z
  caxis([6.e7,8.e7]); %full range for Z
  colormap Bone; 
end

tf = strcmp(myChoice,'T'); %T in units of kg/m^2
if tf==1
  cRangeEP = [1000000 : 100000 : 2700000.]; %BEST for reg temmperature
  %caxis([1000000.,2700000]);% max2004 was 525000  %BEST for reg temperature
  caxis([2460000.,2500000]);% max2004 was 525000  %BEST for reg temperature
  colormap Jet; 
end

tf = strcmp(myChoice,'EP');
if tf==1
% cRangeEP = [-.000100:.00002:.00004];%BEST for EP
%above temp off
 cRangeEP = [gglobalMin:0.0000002:gglobalMax] %trying for EP this auto scale
% leads to a very muddy outcome

caxis([-.0001,0.00004]);%BEST for EPcaxis
%above temp off

%caxis([gglobalMin,gglobalMax]);%trying for EP, muddy!
 %colormap (flipud(cool));% nice for brilliant effect, maybe too much sometimes
colormap Winter; %Jet; 
end

tf = strcmp(myChoice,'LEDIV');
if tf==1
 %cRangeEP = [-250: 50. : 250]; %BEST for LEDIV
 caxis([-250,250]);%max min try for 5yta cases
% caxis([-1500,1000]);%cRange BEST for LEDIVgglobalMax
 %caxis([gglobalMin,gglobalMax]);
 colormap ('hot'); 
end
%}
  end %end of trendflag test


 % view([-7 85]);  %best  2019 prev best for surf plots for my paper  -45  67,
 % camzoom(2);   %best most recent for EP surface at least
   
   %colormap (flipud(cool));%Winter Hot Bone Jet Cool HSV%flipup reverses
%                                and note that the 1st letter is now lower
%                                case
%colormap Bone;    %best for EP Winter
 %contourf (Vq,cRangeEP);%the MASTER CONTOUR assignment
     % axis on;   % 
 %caxis([gglobalMin, gglobalMax]); %*****************generic default
       %the caxis values part 1 of the color contour range
     %caxis([5.6e7,8.e7]); %full range for Z
%caxis([7.7,8.e7]); %for Z as surface   FOR PAPER     caxis([7.4,8.e7]);
     %caxis([6.1,6.5]);%  %best for log temperature 
 %caxis([1000000.,3000000]);% max2004 was 525000  %BEST for reg temperature   
%caxis([-.0004,0.0002]);%BEST for EP
%caxis([-.00000001,0.00000002]); %best for EP Trend all months 
%caxis([-10e-5,4e-5]); %best for EP Trend all months
     %caxis([-.0001,0.00004]);%previous best for EP
     %caxis([-.0006,0.00003]);%full cRange for EP
     %caxis([-900,400]);%cRange fullest for LEDIV
%caxis([-250,250]);%cRange BEST for LEDIV
%caxis([-1.,1.0]);%cRange BEST for twwwp correl
   %OTHER ways to plot such as mesh or surface
          %mesh(Vq);    %  surfc(Vq);
          % surf(negVq);  %surf(ITCZ); %don't use any of these
%next four commands specifically for Z geopot. height surface plots for my
%paper
%{    
%surface parameters FOR PAPER
 surf(Vq);  %CURRENTLY BEST for at least EP
     xlim([-100,600]);
     ylim([0,300]);
  zlim([-.0004,0.0002]);%%best most recent for EP surface
  view([-7 85]);  %best  2019 prev best for surf plots for my paper  -45  67,
  camzoom(3);   %best most recent for EP surface at least
        % zlim([7.7e7 8.e7]); %best for surf plots for my paper 
        % zlim([5.6e7 7.84e7]);  %6.e7 8.e7   for Z
        %zlim([-250,250])%%best most recent for LEDIV surface
       % view([0 0]); %(0,0) gives view due north from above south pole at base level,
       %  view([0,90]);  %gives view due west from mid level and latitude. % 90 90 is top down
       % first number is rotation around z axis starting from neg y axix,
       % so positive numbers rotate scene ccw and neg numbers produce cw
       % rotations  
           %zoom (2.6)% old replaced with camzoom command
       %view(-35,45);  %conventional oblique
       %view([0, 84]); %what I once used for many
        %light('Position',[100 -520 9000000]);  %best for surf plots for my paper
        %light('Position',[100 -20 9000000]); % super best?
        light('Position',[-1 0 1]); % super best?
%}

% {
  if GridScale == 2
   %set(gca,'ZDir','reverse')%FOR ep ONLY
   set(gca,'XTick',[(0:10.666667:128)]);
   set(gca,'YTick',[(0:5.333333:64)]);

  elseif GridScale == 3
  % set(gca,'ZDir','reverse')%FOR ep ONLY
   set(gca,'XTick',[(0:5.333333:64)]);
   set(gca,'YTick',[(0:2.666667:32)]);
  else %when GridScale is equal to 1, the default
   %set(gca,'ZDir','reverse')%FOR EP onLY
   set(gca,'XTick',[(0:42.666667:512)]);
   set(gca,'YTick',[(0:21.333333:256)]);

  end
   xticklabels({'0E','30E','60E','90E','120E','150E','180','150W','120W','90W','60W','30W','0W'});
   yticklabels({'90S','75S','60S','45S','30S','15S','0','15N','30N','45N','60N','75N','90N'});
   %below was older command label approach which was superceded in matlab
   %upgrade. new has somewhat less control esp for fonts but can learn
   %later
 % set(gca,'XTickLabel','0|30E|60E|90E|120E|150E|180|150W|120W|90W|60W|30W|0','FontWeight','bold','FontSize',12);
 % set(gca,'YTickLabel','90S|75S|60S|45S|30S|15S|0|15N|30N|45N|60N|75N|90N','FontWeight','bold','FontSize',12);
 %&&&&&&&& END CONTOURING FEATURES &&&&&&&&&&&&
 %}
%grid on;
 %  axis off;
   hold on;
%#########  mostly GRID SCALE DEPENDENT CODE FOR OVERLAYs below    #####################
% {
   % SETTINGS FOR ORIGINAL FINE scale grid.  Working on this now
   %{
 TpolyX2 = [192,192,256,256,192];
 TpolyY2 = [136,122,122,136,136];
 UpolyX2 = [355,355,363,363,355];
 UpolyY2 = [183,176,176,183,183];
 TpolyCenX = [223,223,225,225,223];
 TpolyCenY = [130,128,128,130,130];
 %}
  TpolyX2 = [192,192,256,256,192];
 TpolyY2 = [135,121,121,135,135];
 UpolyX2 = [355,355,363,363,355];
 UpolyY2 = [183,176,176,183,183];
 TpolyCenX = [223,223,225,225,223];
 TpolyCenY = [130,128,128,130,130];
 
 %  SETTINGS FOR COARSE grid for plotting only when COARSE grid is used.
   TcpolyX2=[48,48,64,64,48];
   TcpolyY2=[34,30,30,34,34];
   UcpolyX2=[89,89,91,91,89];
   UcpolyY2=[46,44,44,46,46];
   
  %  ColoradoX =[357,357,364,364,357];
 % ColoradoY =[187,181,181,187,187];
 
  HwipolyX2 = [263,263,312,312,263];
 HwipolyY2 = [147,169,169,147,147];

mylinwid = 1;

if GridScale == 2 % i.e. coarse still need to fix lat for all coarse
    twwpCoarsePatch=plot(TcpolyX2,TcpolyY2,'LineWidth',mylinwid);
    %TWWPcenterPoint= scatter(56.,32.,4,'x','MarkerEdgeColor','g','MarkerFaceColor','g')
    urgwCoarsePatch=plot(UcpolyX2,UcpolyY2,'LineWidth',mylinwid);
   % {
   %temporary out for special rhino 3D treatment
   
   %PnPpoint = scatter(90.424,44.874, 10,'b');
   PnPpoint= scatter(90.424,44.874,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   Animaspoint= scatter(89.528,45.235,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   Gilapoint= scatter(89.409,43.933,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   %GSLpoint= scatter(88.102,46.660,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   LFRUTpoint= scatter(88.702,46.616,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
    GyrePoint = scatter(55,39,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   % BioBiopoint=scatter(102.222,19.082,'o','MarkerEdgeColor','k','MarkerFaceColor','w','LineWidth',mylinwid);
   BioBiopoint=scatter(102.222,19.082,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
   Bithurpoint= scatter(28.542,41.641,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   LAndvLpoint= scatter(74.667,42.84,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   Tahitipoint= scatter(74.880,25.884,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
   Charlestonpoint= scatter(99.58,43.83,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   AlwaysWetPoint= scatter(74.667,40.3,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   %HawaiiPoint = scatter(72.569,39.289,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   
   OLRX=[56.889,71.111];
   OLRY=[32.178,32.178];
   OLRline=plot(OLRX,OLRY,'red','LineWidth',mylinwid);
  % POLEPlotBot=[56.,32.,0.];
  % POLEPlotTop=[56.,32.,8.e7];
  % POLEPLOT = plot(POLEPlotBot,POLEPlotTop,'blue','LineWidth',mylinwid);

   %use for coarser grid
else   %i.e. original fine
    
 %  ColoradoFinePatch=plot(ColoradoX,ColoradoY,'MarkerEdgeColor','k','LineWidth',mylinwid);
    %PnPpoint = scatter(361.696,179.496, 15,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
    %Gilapoint= scatter(357.636,175.732,15,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
    twwpPatch2 = plot(TpolyX2,TpolyY2,'LineWidth',mylinwid);
   % HwiPatch2 = plot ( HwipolyX2,HwipolyY2,'LineWidth',mylinwid);
    %TahitiPoint = scatter(299.216,103.757,'LineWidth',mylinwid);
    %twwpCenPatch = plot(TpolyCenX,TpolyCenY);
    %urgwPatch = plot(UpolyX2,UpolyY2,'LineWidth',1);
  %Greenland Assets
   NGRIP=scatter(451.792,235.52,'o','MarkerEdgeColor','k','LineWidth',1);
   Summit=scatter(457.238,231.935,'o','MarkerEdgeColor','k','LineWidth',1);
   Nuuk=scatter(438.48,219.99,'o','MarkerEdgeColor','k','LineWidth',1);
   %wallace 2019 assets
   PnPpoint= scatter(361.696,178.785,'o','MarkerEdgeColor','k','LineWidth',1);%corrected
   Animaspoint= scatter(358.113,180.228,'o','MarkerEdgeColor','k','LineWidth',1);%corrected
   Gilapoint= scatter(357.636,175.021,'o','MarkerEdgeColor','k','LineWidth',1);%corrected
   %Antarctica assets
   SouthPolePoint = scatter(001.,001.,'o','MarkerEdgeColor','k','LineWidth',1);%
   VostokPoint = scatter(151.942,17.117,'o','MarkerEdgeColor','k','LineWidth',1);%
   McMurdoPoint = scatter(237.065,18.003,'o','MarkerEdgeColor','k','LineWidth',1);%
   %DomeAPoint = scatter(110.033, 13.701,'o','MarkerEdgeColor','y','LineWidth',1);
   %DomeCPoint = scatter(175.502,21.191,'o','MarkerEdgeColor','y','LineWidth',1);%
   %TaylorDomePoint = scatter(225.730,17.351,'o','MarkerEdgeColor','y','LineWidth',1);%
   %older VostokPoint = scatter(151.988,16.403,'o','MarkerEdgeColor','y','LineWidth',1);%

   %LawDomePoint = scatter(160.474,33.090,'o','MarkerEdgeColor','y','LineWidth',1);%
   %SipleStationPoint = scatter(119.348,20.030,'o','MarkerEdgeColor','y','LineWidth',1);%
   %PolarStudy assets
     %KamchatkaSwirlPoint = scatter(245,237,'o','MarkerEdgeColor','g','LineWidth',1);%
     %BarrowPoint = scatter(289.021,230.092,'o','MarkerEdgeColor','g','LineWidth',1);%

%other studies
%{
   %PollenStudy assets   
     %SeoulPoint = scatter(180.612,182.135,'o','MarkerEdgeColor','b','LineWidth',1);%
     %WuhanPoint = scatter(162.595,172.293,'o','MarkerEdgeColor','b','LineWidth',1);%
     %SingaporePoint = scatter(147.701,130.546,'o','MarkerEdgeColor','b','LineWidth',1);%
     %GuamPoint = scatter(205.929,147.832,'o','MarkerEdgeColor','b','LineWidth',1);%
%Aukland= scatter(249,76,'o','MarkerEdgeColor','y','LineWidth',1); 
   %Jacobschaven=scatter(438.5,225.7,'o','MarkerEdgeColor','y','LineWidth',1);
   %NWGreen=scatter(432.,240.,'o','MarkerEdgeColor','y','LineWidth',1);
   %NEGreen=scatter(467.,236.,'o','MarkerEdgeColor','y','LineWidth',1);
   %SEGreen=scatter(456.,223.,'o','MarkerEdgeColor','y','LineWidth',1);

   %TCAZpoint= scatter(353.702716,177.0382222,10,'k');
   %SRWIDpoint= scatter(345.6272593,191.6381235,10,'k');
   %SFKRCApoint= scatter(343.9320494,179.5377778,10,'k');
   %RRORpoint= scatter(337.9318518,189.4518518,10,'k');

   %NRCOpoint= scatter(360.2646913,181.4546173,10,'k');
   %GRGUTpoint= scatter(355.3414,184.15802,10,'k');
   %CRNMpoint= scatter(363.55042,179.42021,10,'k');
   %BRNMpoint= scatter(363.87292,174.54804,10,'k');
   %AkRpoint= scatter(362.30163,182.662,10,'k');%corrected
   %GSLpoint= scatter(352.408,185.929,10,'k');%corrected
   %Glacier National Park (GNP)
    %GNPpoint = scatter(350.141,197.257,10,'b');%corrected
   %San Juan Mtns (silverton, CO) point
   %Pyrnpoint = scatter(511,191,10,'b');%corrected
    %SJMpoint = scatter(358.879,181.821,10,'w');%corrected
   %OtowiNMpoint= scatter(361.0418569,179.022,10,'k');
  % AlbuquerqueNMpoint= scatter(360.,178.6,5,'y');
   %Africa Study assets
   CongoRPoint = scatter(21.76,122.596,'o','MarkerEdgeColor','b','LineWidth',1);%Congo
    OkavangoRPoint = scatter(31.004,103.111,'o','MarkerEdgeColor','k','LineWidth',1);%Botswana
    OuerghaRPoint = scatter(504.875,177.948,'o','MarkerEdgeColor','k','LineWidth',1);%Morroco MA
   %too short recordGambellaRPoint = scatter(49.18,140.444,'o','MarkerEdgeColor','b','LineWidth',1);%Ethiopia ET
   AwashRPoint = scatter(54.898,141.084,'o','MarkerEdgeColor','k','LineWidth',1);%Ethiopia ET
   GarissaRPoint = scatter(56.462,128.071,'o','MarkerEdgeColor','k','LineWidth',1);% Kenya KE
   AswanPoint = scatter(46.791,162.788,'o','MarkerEdgeColor','k','LineWidth',1);% Egypt
   KhartoumPoint = scatter(46.293,150.926,'o','MarkerEdgeColor','k','LineWidth',1);% Sudan
   RoseiresPoint = scatter(48.896,145.564,'o','MarkerEdgeColor','k','LineWidth',1);%Blue Nile Roseires
   NigerPoint = scatter(501.262,147.010,'o','MarkerEdgeColor','k','LineWidth',1);%Niger at Koulikoro Mali

   %South America assets
   FortalezaPoint = scatter(457.206,123.402,'o','MarkerEdgeColor','b','LineWidth',2);%
   ParanPosadPoint = scatter(432.526,89.785,'o','MarkerEdgeColor','r','LineWidth',1);%
   BanabuiuPoint = scatter(455.991,120.754,'o','MarkerEdgeColor','b','LineWidth',1);%
   AcarauPoint = scatter(454.613,123.477,'o','MarkerEdgeColor','r','LineWidth',1);%   
   JaguaribePoint = scatter(456.107,119.656,'o','MarkerEdgeColor','r','LineWidth',1);%
   MataderoPoint = scatter(399.692,124.599,'o','MarkerEdgeColor','y','LineWidth',1);%   
   % }  
   OLRX=[227.556,284.444];
   OLRY=[128.00,128.00];
  OLRline=plot(OLRX,OLRY,'red','LineWidth',mylinwid);
   Bithurpoint= scatter(114.168,165.854,'o','MarkerEdgeColor','b','LineWidth',mylinwid);%corrected
   BioBiopoint=scatter(408.889,75.619,'o','MarkerEdgeColor','b','LineWidth',mylinwid);%corrected
   LAndvLpoint= scatter(298.667,170.667,'o','MarkerEdgeColor','b','LineWidth',mylinwid);%corrected
   Tahitipoint= scatter(299.52,103.046,'o','MarkerEdgeColor','b','LineWidth',mylinwid);%corrected
   GyrePoint = scatter(220.4,156.444,'o','MarkerEdgeColor','b','LineWidth',mylinwid);%corrected
   AlwaysWetPoint= scatter(294.,158.,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
%}
    %use for finer original grid
end

% NOTE!!  I can set all 'plot' commands to 'fill' for continents  
% for a specific purpose.  when done must change back
% and change the 'yellow' lines back to black
%note made in late September 2019

%latest looks to mylinwid to discriminate btwn coarse and fine.
load Australia.csv %change name here as needed
LongCoord = Australia(:,1);%change name here as needed
LatCoord = Australia(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load WEurAfAs.csv %change name here as needed
LongCoord = WEurAfAs(:,1);%change name here as needed
LatCoord = WEurAfAs(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load EEurAfAs.csv %change name here as needed
LongCoord = EEurAfAs(:,1);%change name here as needed
LatCoord = EEurAfAs(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load NAmerica11.csv %change name here as needed
LongCoord = NAmerica11(:,1);%change name here as needed
LatCoord = NAmerica11(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load SAmerica.csv %change name here as needed
LongCoord = SAmerica(:,1);%change name here as needed
LatCoord = SAmerica(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load UK.csv %Needs Work change name here as needed
LongCoord = UK(:,1);%change name here as needed
LatCoord = UK(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load Borneo.csv %change name here as needed
LongCoord = Borneo(:,1);%change name here as needed
LatCoord = Borneo(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load Phillipines.csv %change name here as needed
LongCoord = Phillipines(:,1);%change name here as needed
LatCoord = Phillipines(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load PPNewGuinea.csv %change name here as needed
LongCoord = PPNewGuinea(:,1);%change name here as needed
LatCoord = PPNewGuinea(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load NewZealand.csv %change name here as needed
LongCoord = NewZealand(:,1);%change name here as needed
LatCoord = NewZealand(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load Tasmania.csv %change name here as needed
LongCoord = Tasmania(:,1);%change name here as needed
LatCoord = Tasmania(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load JavaWest.csv %change name here as needed
LongCoord = JavaWest(:,1);%change name here as needed
LatCoord = JavaWest(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load Madagascar.csv %change name here as needed
LongCoord = Madagascar(:,1);%change name here as needed
LatCoord = Madagascar(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load RussianPolarIsland.csv %change name here as needed
LongCoord = RussianPolarIsland(:,1);%change name here as needed
LatCoord = RussianPolarIsland(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load BaffinIsland.csv %change name here as needed
LongCoord = BaffinIsland(:,1);%change name here as needed
LatCoord = BaffinIsland(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load Greenland3.csv %Needs Workchange name here as needed
LongCoord = Greenland3(:,1);%change name here as needed
LatCoord = Greenland3(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load Antarctica5.csv %Needs Work was vs 3 changed Jul 2021
LongCoord = Antarctica5(:,1);%change name here as needed
LatCoord = Antarctica5(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'cyan','LineWidth',mylinwid);
load Hawaii2.csv %Needs Workchange name here as needed
LongCoord = Hawaii2(:,1);%change name here as needed
LatCoord = Hawaii2(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
%plot(longdeg,latdeg,'black','LineWidth',mylinwid);
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load HawaiiX1.csv %Needs Workchange name here as needed
LongCoord = HawaiiX1(:,1);%change name here as needed
LatCoord = HawaiiX1(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
%plot(longdeg,latdeg,'black','LineWidth',mylinwid);
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load HawaiiX2.csv %Needs Workchange name here as needed
LongCoord = HawaiiX2(:,1);%change name here as needed
LatCoord = HawaiiX2(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
%plot(longdeg,latdeg,'black','LineWidth',mylinwid);
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load HawaiiX3.csv %Needs Workchange name here as needed
LongCoord = HawaiiX3(:,1);%change name here as needed
LatCoord = HawaiiX3(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
%plot(longdeg,latdeg,'black','LineWidth',mylinwid);
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load HawaiiX4.csv %Needs Workchange name here as needed
LongCoord = HawaiiX4(:,1);%change name here as needed
LatCoord = HawaiiX4(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
%plot(longdeg,latdeg,'black','LineWidth',mylinwid);
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load Caspian.csv %Needs Workchange name here as needed
LongCoord = Caspian(:,1);%change name here as needed
LatCoord = Caspian(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
%plot(longdeg,latdeg,'black','LineWidth',mylinwid);
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load MediterraneanAndBlack.csv %Needs Workchange name here as needed
LongCoord = MediterraneanAndBlack(:,1);%change name here as needed
LatCoord = MediterraneanAndBlack(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load MediterraneanAndBlackWest.csv %Needs Workchange name here as needed
LongCoord = MediterraneanAndBlackWest(:,1);%change name here as needed
LatCoord = MediterraneanAndBlackWest(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
load CubaHispanolia.csv %Needs Workchange name here as needed
LongCoord = CubaHispanolia(:,1);%change name here as needed
LatCoord = CubaHispanolia(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
%{
load NM.csv %change name here as needed
LongCoord = NM(:,1);%change name here as needed
LatCoord = NM(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load AZ.csv %change name here as needed
LongCoord = AZ(:,1);%change name here as needed
LatCoord = AZ(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load CO.csv %change name here as needed
LongCoord = CO(:,1);%change name here as needed
LatCoord = CO(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);

load UT.csv %change name here as needed
LongCoord = UT(:,1);%change name here as needed
LatCoord = UT(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
%}
load SSNcase1.csv % load first solar strip for cross corr


 %surf(Vq);
PrintSpan = num2str(rspan);
PrintYear = num2str(myYear);
PrintMonth = num2str(myMonth);
PrintBegYear = num2str(myBegYear);
PrintEndYear = num2str(myEndYear);
TitleYearBanner = strcat(PrintBegYear,'-to-',PrintEndYear,'-at-',PrintSpan,' month increments');
PrintGridScale = num2str(degPercolumn);

  %latest greatest outside of multi loop  
%  title({['Beginning and ending date for Avg.  ',PrintBegYear, ', ', PrintEndYear,', ', PrintSpan,' month increments,', ' Contours of Z kg/m lat long cells each ',PrintGridScale, ' deg.'] ...

%title({'EP MM/DAY','Beginning and ending date for Average.  ',TitleYearBanner,},'FontSize', 12);  % );,'FontSize', 14,'FontWeight','bold'
%works  below
 %title({['Beginning and ending date for Avg.  ',TitleYearBanner, ' Contours of Z kg/m lat long cells each ',PrintGridScale, ' deg.'] ...
 %     ,' www.abeqas.com/stochastic-landscapes/'},'FontSize', 8);
  %works above
  if TrendFlag == 2
tf = strcmp(myChoice,'Z');
if tf==1
    %ERAI full atm. thickness  GEOPOTENTIAL HEIGHT (Z)   KG/M
  title({['UCAR full atm. thickness  GEOPOTENTIAL HEIGHT (Z) Trend   KG/M/month'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end

tf = strcmp(myChoice,'T');
if tf==1
    %ERAI full atm. thickness  TEMPERATURE K kg/m^2, or TEMPERATURE TREND K kg/m^2/month'
  title({['UCAR full atm. thickness  TEMPERATURE K kg/m'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end

tf = strcmp(myChoice,'EP');
if tf==1
    %ERAI full atm. thickness  EVAPORATION - PRECIPITATION (EP)MM/DAY
    %  title({['ERAI full atm. thickness  EVAPORATION - PRECIPITATION (EP) Trend MM/DAY/month'] ...
  title({['UCAR full atm. thickness  EVAPORATION - PRECIPITATION (EP) mm/day'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end

tf = strcmp(myChoice,'LEDIV');
if tf==1
    %'ERAI full atm. thickness  LEDIV, (W/M^2)
%      title({['ERAI full atm. thickness  LEDIV TREND, (W/M^2/month)']
  title({['UCAR full atm. thickness  LEDIV, (W/m^2)'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end
  end % end trendflag test
  
   if TrendFlag == 1
  tf = strcmp(myChoice,'T');
if tf==1
    %ERAI full atm. thickness  TEMPERATURE K kg/m^2, or TEMPERATURE TREND K kg/m^2/month'
  title({['UCAR full atm. thickness draft TEMPERATURE TREND K kg/m/month'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end
   end


  
%{
% seriously good annotation box for routine use
  dim = [.03 .18 .03 .03];str = {strcat(myChoice,' ',' ',PrintYear),'copyright 2019, MW&A','www.abeqas.com','data from http://www.cgd.ucar.edu/','cas/catalog/newbudgets/','index.html#ERBEFs' };
a=annotation('textbox',dim,'String',str,'FitBoxToText','on');;a.Color = 'red';  a.FontSize = 12;

dim = [.01 .8 .03 .03];str2 = {strcat('Evaporation'),('minus'),('Precipitation'),PrintYear};
b=annotation('textbox',dim,'String',str2,'FitBoxToText','on');b.Color = 'blue';  b.FontSize = 22;
%}
  % title({['EP mm/day'] ...
  %    ,'Beginning and ending date for Avg.  ',TitleYearBanner,},'FontSize', 12);  % 'FontWeight', 'bold');
   %  title(['Month.Year  ',PrintYear, '        Contours of Z kg/m, vectors of U,V  lat long cells each 2.8125 deg.'],'FontSize', 12)
    % latest greatest outside of multi loop 
        %PngOutMeanNamestring = strcat(Pathstring2,FileAmean,begMonth);
     PngOutMeanNamestring = strcat(Pathstring2,FileAmean,myChoice,TitleYearBanner,'.png');
     %PngOutMeanNamestring = strcat(Pathstring2,FileAmean,PrintYear,'.png');
   % PngOutMeanNamestring = strcat(Pathstring2,FileAmean,r);
   saveas(gcf,PngOutMeanNamestring,'png');
   %turned off printing of this for now while focusing on cousin code
%}
 %  end
 %Z kg/m
 %GEOPOTENTIAL HEIGHT (Z)   KG/M, EVAPORATION - PRECIPITATION (EP)MM/DAY,
 % TEMPERATURE kg/m^2,  LEDIV, (W/m^2)
  %Contours of Z kg/m, Contours of EP mm/day, Contours of T K kg/m^2
  %Divergence of Latent Energy (LEDIV) W/m^2