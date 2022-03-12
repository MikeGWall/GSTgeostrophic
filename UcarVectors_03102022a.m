%UcarVectors program.  Built over several years by Michael G. Wallace for independent research
%Welcome new programmers and scientists. Through BitHub, we can advance together, since my
%programming could be significantly improved.  Stay tuned for more development content
%no representations are made or implied.  Use at own risk!
%set trendflags.. non-Trend = 2 or any number other than 1 Trend = 1
TrendFlag= 2; % flag to display trend or correlation products
ModeFlag = 1; % tbd: flag to overlay vector results over previously constructed scalar output
% currently hardwired to NOT do that.  Ultimately all flags will be incorporated into a GUI
%The ncdf parameter physical equations derive from the discussion in Stepaniak Vertically Integrated Mass, 
%Moisture, Heat, and Energy Budget Products Derived from the NCEP_NCAR ReanalysisCapture

%if unable to find original .nc files, contact mwa@abeqas.com
%
% When ModeFlag is 1, make sure the month loop is  properly synchronized with the scalar parameter map
% and the output files for both programs point to the proper folders  but now this runs in STAND ALONE MODE

%an example input file open command:  ncid = netcdf.open('ERAI.LEDIV.1979-2014.nc','NC_NOWRITE');
%hold off; can toggle depending on graphic plans

% First read in Q vector set,  U is zonal and V is meridional.  There is no vertical wind set in this database
ncid = netcdf.open('ERAI.U.1979-2014.nc','NC_NOWRITE');
[ndims,nvars,natts,unlimdimID]= netcdf.inq(ncid);
ncdisp('ERAI.U.1979-2014.nc');% tip: run these lines on console first, to check variable dimensions etc.
LEDIVData = ncread('ERAI.U.1979-2014.nc','U');
% as LEDIV was my first successful run ++++++**************** tbd genericize this first variable
netcdf.close(ncid);
SizeOfLEDIVData = size(LEDIVData);
[Longitude, Latitude, monthYear,] = size(LEDIVData);

%set up all figures for white background
%whitebg([0 .5 .6])
whitebg('white')
set(gcf,'Color','white')
%just saved few pathstring txt for my PC  others will enter their own paths  of course
Pathstring2 = 'D:\2020UCARresearch\UCARassets\Velocities\';
myChoice = 'GeostrophWind'; %for assigning part of the name of output file
% final manual entry, change prefix to ..MeanMonthly_' as desired ++++++****************
FileAmean = strcat('UCARUV',myChoice);    %enter file prefix here only
%***********************************************
%stable settings for UCAR data read
nsets = monthYear;  %432 sets from file covering 432 months 1-1979 thru 12-2014
nlongrows = Longitude; %512 rows from file for longitude
nlatcols = Latitude;% 256 columns from file for each latitude set
ncols = nsets*nlatcols;
nrows = nlongrows;
%Manual Setting REQUIRED VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%NOTE..October 2019 coarsening algorithm is not complete. must correct for northern and
%eastern bias due to the crude approach I adopt for now. NOTE NOTE NOTE
GridScale = 1;% 1 for original fine grid, 2 for coarse grid
if GridScale == 2
    degPercolumn = 2.8125;  %use for coarser grid
    rowsperSet = 64; %use for coarse grid
elseif GridScale == 3
    degPercolumn = 5.625;  %use for coarser grid
    rowsperSet = 42; %use for coarse grid
else
    degPercolumn = 0.703125; %use for finer original grid
    rowsperSet = 256; %use for fine grid
end
%Manual Setting REQUIRED ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MyTrendArray = zeros(512,256);
MyUTrendArray = zeros(512,256);
%LatScale = [89.5:-0.703125:-90.];%legacy
%LongScale = [0.0:0.703125:359.5];%legacy
 LatentH = zeros(nlongrows, nlatcols);
 meanLatH = zeros(nlongrows, nlatcols);
 zLatH = zeros(nlongrows, nlatcols);
 testZ = zLatH';
 zPlane = zeros(nlongrows, nlatcols);
 meanLatHTemp = meanLatH;
 myAlat = zeros(nlatcols, nlongrows);
 PolarStripCalcV = zeros(nsets,Longitude);
 PolarAverage = zeros(nsets,1);
SouthPoleCalc = zeros([nsets,1]);
VostokCalc = zeros([nsets,1]);
McMurdoCalc= zeros([nsets,1]);
KamStripCalc = zeros(nsets,Latitude);
 %uSquare = meanLatH;
 %vSquare = meanLatH;
 %{
 MyWindCorArray = zeros(nlongrows,nlatcols);
 MyWindCorXBox = zeros(nsets,512,256);
 MyWindCorYBox = zeros(nsets,512,256);
 MyWindCorBox = zeros(nsets,512,256);
%} 
CaptureITCZFLOWY = [25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45];
 CaptureITCZFLOWX = [82,82,82,82,82,82,82,82,82,82,82,82,82,82,82,82,82,82,82,82,82];
 
 TpolyX2 = [192,192,256,256,192];
 TpolyY2 = [136,122,122,136,136];
 UpolyX2 = [365,365,363,363,365];
 UpolyY2 = [183,176,176,183,183];
 TpolyCenX = [223,223,225,225,223];
 TpolyCenY = [130,128,128,130,130];
 %
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
ITCZInflowsCapture82degLong = zeros([nsets,1]);
TWWPBox = zeros([65,15]);
TWBox = zeros([nsets,1]);
   boxlongspan = 191; boxlatspan = 121; %currently for TWWPBox only
   KamStripCalc = zeros(nsets,Latitude);
HwiBox = zeros([50,22]);
   Hwiboxlongspan = 262; Hwiboxlatspan = 146; %currently for TWWPBox only
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
%Manual Setting REQUIRED to loop through the months of interest
rbeg = 4;%13 to 72 for 1985 5 yta %253-312 is for 2005yta 230 el nino  la nina 122
rend = 4;  %432 is final month for full series
rspan = 1;% set to 1 for consecutive months, set to 12 to capture the same month, one year apart
monthVector = (rbeg:rspan:rend );
monthVectorT = monthVector';
mymonthsize = size(monthVectorT,1);
MyCorBox = zeros(mymonthsize,512,256);
MyCorUBox = zeros(mymonthsize,512,256);
AnimasCalc = zeros([mymonthsize,1]);

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

SoPoCalcX = zeros(nsets,1);%if rr == 206 && rrr == 242
SoPoCalcY = zeros(nsets,1);%if rr == 206 && rrr == 242
SoPoCalc = zeros(nsets,1);%if rr == 206 && rrr == 242
globalVCalc = zeros([nsets,1]);
AlbVecX = zeros(nsets,1); %if rr == 360 && rrr == 179
AlbVecY = zeros(nsets,1); %if rr == 360 && rrr == 179
AlbVecAll = zeros(nsets,1); %capture magnitude of vector at Albuquerque for up to all months
FortVecCalc1 = zeros(nsets,1);
FortVecCalc2 = zeros(nsets,1);
FortVecCalcAll = zeros(nsets,1);
 %capture magnitude of vector at Christchurch NZ for up to all months
NZVecCalc1 = zeros(nsets,1);
NZVecCalc2 = zeros(nsets,1);
NZVecCalcAll = zeros(nsets,1);
%capture magnitude of vector at Aukland NZ for up to all months
AukVecCalc1 = zeros(nsets,1);
AukVecCalc2 = zeros(nsets,1);
AukVecCalcAll = zeros(nsets,1);
%set up for developing avg values within TWWP over time.  First try a
%single cell at row (longitude)224 and column (lat) 129
twwpCalc1 = zeros(nsets,1); %overkill, may change or use for another role
twwpCalc2 = zeros(nsets,1);
% bullseye1 = zeros(nsets,1);
  bullseye2 = zeros(nsets,1);
%  laVLCalc =  zeros([nsets,1]);
%Charleston =  zeros([nsets,1]);
ITCZInflowsCapture82degLong = zeros([nsets,1]);
ITCZInflowsCapture270degLong = zeros([nsets,1]);
%set up for rcount
%Manual Setting REQUIRED ***********************************************
%noting month 374, low extreme for Artic Oscillation
%13-72 is 5yta ending 'Jan1 1985',%73-142 is 5yta ending 'Jan1 1990'
%133-192 is 5yta ending 'Jan 1 1995,%193-252 is 5yta ending 'Jan1 2000'
%253-312 is 5yta ending 'Jan 1 2005',%313-372 is 5yta ending 'Jan 1 2010'
%373-432 is 5yta ending 'Jan 1 2015'    %61 to 120 5yta ending Jan 1 1988
%409-411 first three months of 2013    %august 1999 is 248
%305 may 2004 high tornado month 329 low action  365 also
%{
rbeg = 12;
rend = 12;
%rend = 432;8
rspan = 1;
%rspan = 1;
monthVector = (rbeg:rspan:rend );
monthVectorT = monthVector';
mymonthsize = size(monthVectorT,1);
MyCorBox = zeros(mymonthsize,512,256);
AnimasCalc = zeros([mymonthsize,1]);
MyCorArray = zeros(nlongrows,nlatcols);
%}

% for jan 1979 start **********************************
myBegYear = (23748 + rbeg)/12;
myEndYear = (23748 + rend)/12;

     myglobalMax = 0.0;
     myglobalMin = 100000000.0;

kount = 0;
 %for r = 1:nsets  %loop through each month (nsets)
%for r = 1:12:nsets  %loop through each 12th month
for r = rbeg:rspan:rend    
  % calculate year.mon for figure title
       myYear=(23748+r)/12;%23748 means #months since 1900, so Jan, 1979
          myMonth = r;
  %hold on;
    kount = kount +1;
    begMonth = num2str(kount);
        inputKount = 0;

    startcol = ((r-1) * nlatcols)+1;%
    endcol  = (startcol + nlatcols)-1;
    for rr = 1:nlongrows %loop through 512 rows, which are longitude
            innerK=0;
            rback=rr-1;
          for rrr = 1:nlatcols  %cols are latitude, south pole at rrr =1
          %for rrr = startcol:endcol
            outerK = startcol + innerK;
            innerK = innerK + 1;
           %LatentH(rr,rrr)= LEDIVData(rr,innerK);
           %THIS IS PRIME   
           LatentH(rr,rrr)= LEDIVData(rr,outerK);
           % LatentH(rr,rrr)= testb(rr,outerK);%trying variation on Works Prime
            % first setting up for capturing mins and maxes
             if abs(LatentH(rr,rrr)) < myglobalMin % & LatentH(rr,rrr) ~= 0
               myglobalMin = LatentH(rr,rrr);
             end
             if abs(LatentH(rr,rrr)) > myglobalMax % & LatentH(rr,rrr) ~= 0
              myglobalMax = LatentH(rr,rrr);
             end
           
           if kount == 1
           %if r == 1
             meanLatH(rr,rrr)= LatentH(rr,rrr);
             meanLatHTemp (rr,rrr)= LatentH(rr,rrr);
           end
           if kount > 1
            %if r > 1
             meanLatH(rr,rrr)= (LatentH(rr,rrr)+ meanLatHTemp(rr,rrr));
             meanLatHTemp(rr,rrr)=meanLatH(rr,rrr);
           end
         %uSquare (rr,rrr) = meanLatH(rr,rrr)^2;%trying to calc scalar mag in steps
%SoPoCalcX = zeros(nsets,1);%if rr == 206 && rrr == 242
            if rr == 293 && rrr == 157
                 HWSCalcX(kount)=LatentH(rr,rrr);
             end

            if rr == 205 && rrr == 232
                 SoPoCalcX(kount)=LatentH(rr,rrr);
             end
             if rr == 224 && rrr == 129
                 twwpCalc1 (kount)=LatentH(rr,rrr);
             end
              if rr == 224 && rrr == 160
                 bullseye1(kount)=LatentH(rr,rrr);
              end
             if rr == 299 && rrr == 171
                LaVLCalc(kount)=LatentH(rr,rrr);
             end
            if rr == 398 && rrr == 175
                Charleston(kount)=LatentH(rr,rrr);
            end
            %july2020albuquerque vector captures
            if rr == 360 && rrr == 179
            AlbVecX(kount) = LatentH(rr,rrr);
            end
            %Fortaleza vecture captures
            if rr == 457 && rrr == 123
                  FortVecCalc1(kount) = LatentH(rr,rrr);
            end
            %Christchurch NZ vector captures NZVecCalc1
            if rr == 245 && rrr == 67
            NZVecCalc1(kount) = LatentH(rr,rrr);
            end
            %Aukland NZ vector captures AukVecCalc1
            if rr == 249 && rrr == 76
            AukVecCalc1(kount) = LatentH(rr,rrr);
            end
            if rr == 82 && rrr >= 100 && rrr <= 171%leads to the 59 col array with rr rows
                   inputKount = inputKount + 1;
                   ITCZInflowsCapture82degLong(kount,inputKount)=LatentH(rr,rrr);
            end% with this module, I can read in zonal vel for this vertical strip
                % and then copy and paste into excel for further processing
                % at will
              
          end
    end
    
               % MyCorUBox  for making CORRELATION and/or TREND maps
        for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude
             %MyCorBox(r,rr,rrr)= LatentH(rr,rrr);
             MyCorUBox(kount,rr,rrr)= LatentH(rr,rrr);
         end
        end  % end of dual loop to define the correlation box
    %for rrr = 1:Latitude %loop through cols, which are latitude
            %          KamStripCalc(kount,rrr)= LatentH(245,rrr);
            %end
        %{
      %populating MyWindCorXBox
        for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude
             MyWindCorXBox(r,rr,rrr)= LatentH(rr,rrr);
         end
        end  % end of dual loop to define the global wind x box, which is only a test
    %}
    %result(r) = LEDIVData(kount);
    %test = LEDIVData(:,startcol:endcol);%illegal.  must assign actual #s
                                         %instead of startcol and endcol\
   %accordingly, must build each matrix the loop way see examples below
   
   %testB = LatentH';
   %this assignment to my key "testB" worked and I made 432 plots.  now I turn off plot for other data
   %for key "testB" to be mean of any monthly span, uncomment meanLatH and testB below and comment out testB above
 
  %that's all for change from span avg to individual file generation for a series
   end  % end of month loop
        meanLatH=meanLatHTemp/kount;
      testB = meanLatH';
 %  testZ = zPlane';
   
 clear LEDIVData;
 if TrendFlag == 1
    %If rspan > 1
         for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude 
         %USE THIS!! MyCorSet = corrcoef(SSNcase5, MyCorBox(1:nsets,rr,rrr));
         %USE THIS!!MyCorArray(rr,rrr) = MyCorSet(1,2);
    %can also use  
             %MyCorSet = corrcoef(SSNcase5, MyCorBox(1:nsets,rr,rrr));
    %  MyCorSet = corrcoef(ArcticSepIce, MyCorBox(:,rr,rrr));
             %MyCorArray(rr,rrr) = MyCorSet(1,2); %key for Cor
              p=polyfit(monthVectorT,MyCorUBox(:,rr,rrr),1); %key for Cor
              MyUTrendArray(rr,rrr) = p(1,1);  %key for cor and trend
         end
        end  % end of dual loop for corr and trend outputs
   % end
          TrendUArray=MyUTrendArray';  %key for trend of course
          MyLatUTrend = mean(TrendUArray,2); %to get the av trend vs latitude plot
 end %end of TrendFlag test
     
      %testSegB = testB(60:160,256:356);
   %contourf (testB);
 %@@@@@@@@@ NEXT  refining or coarsening grid @@@@@@@@@@@@@@@
 %%{
 %[Xq,Yq] = ndgrid(1:1:256,1:1:512);%set to basic refined grid 1/1 the entries
  if GridScale == 2
   GriDgi = 4;
   elseif GridScale == 3
   GriDgi = 8;
  else
   GriDgi = 1;
  end
  [Xq,Yq] = ndgrid(1:GriDgi:256,1:GriDgi:512);%set to new coarser grid or to orig if desired
  %[Xq,Yq] = ndgrid(1:4:256,1:4:512);%set to new coarser grid or to orig if desired
%[Xq,Yq] = ndgrid(1:4:256,1:4:512);%set to new coarser grid 1/4 the entries
  %[Xq,Yq] = ndgrid(1:8:256,1:8:512);%set to new coarser grid 1/8 the entries
  [X,Y] = ndgrid(1:1:256,1:1:512);%must be set to original grid
   % [Xq,Yq] = ndgrid(0:4:256,0:4:512);
  %[Zq] = ndgrid(-1:1:1);
   %@@@@@@@@@ FINISHED refining or coarsening grid @@@@@@@@@@@@@@@
% next is key for CONTOURING.. interpolating the original grid to the new grid   
    Fb = griddedInterpolant(X, Y, testB, 'linear');%this creates the master grid for interpolating
    Vqb = Fb(Xq,Yq);  %this used master grid to reassign values to a different grid
% FINISHED interpolating the grid
       
%AND NOW....REPRODUCING ENTIRE LOOP ABOVE for meridional winds
   %read in second vector set
ncid = netcdf.open('ERAI.V.1979-2014.nc','NC_NOWRITE');
[ndims,nvars,natts,unlimdimID]= netcdf.inq(ncid);
ncdisp('ERAI.V.1979-2014.nc');
LEDIVData2 = ncread('ERAI.V.1979-2014.nc','V');
% as LEDIV was my first successful run ++++++****************
netcdf.close(ncid);
SizeOfLEDIVData2 = size(LEDIVData2);
[Longitude, Latitude, monthYear,] = size(LEDIVData2);
%test=LEDIVData2(:,:);
%testc = test'; %inverts the matrix test

kount = 0;
 %for r = 1:12:nsets  %loop through each month
 for r = rbeg:rspan:rend 
            myYear=(23748+r)/12;
 %for r = 1:nsets  %loop through each month (nsets)
%for r = 1:20  %loop through each month for a few years
  % 
  %hold on;
    kount = kount +1;
    begMonth = num2str(kount);
  myTrendXArray(kount)=kount*rspan;
  myTrendX = myTrendXArray';
    startcol = ((r-1) * nlatcols)+1;%trying this
    endcol  = (startcol + nlatcols)-1;
    for rr = 1:nlongrows %loop through rows, which are longitude
            innerK=0;
            rback=rr-1;
          for rrr = 1:nlatcols  %cols are latitude
          %for rrr = startcol:endcol
            outerK = startcol + innerK;
            innerK = innerK + 1;
           %LatentH(rr,rrr)= LEDIVData(rr,innerK);
           %THIS IS WORKS PRIME   
           LatentH(rr,rrr)= LEDIVData2(rr,outerK);
           % LatentH(rr,rrr)= testb(rr,outerK);%trying variation on Works Prime
           
            % continue capturing mins and maxes
             if abs(LatentH(rr,rrr)) < myglobalMin % & LatentH(rr,rrr) ~= 0
               myglobalMin = LatentH(rr,rrr);
             end
             if abs(LatentH(rr,rrr)) > myglobalMax % & LatentH(rr,rrr) ~= 0
              myglobalMax = LatentH(rr,rrr);
             end
           
           if kount == 1
           %if r == 1
             meanLatH(rr,rrr)= LatentH(rr,rrr);
             meanLatHTemp (rr,rrr)= LatentH(rr,rrr);
           end
           if kount > 1
            %if r > 1
             meanLatH(rr,rrr)= (LatentH(rr,rrr)+ meanLatHTemp(rr,rrr));
             meanLatHTemp(rr,rrr)=meanLatH(rr,rrr);
           end
           %SoPoCalcY = zeros(nsets,1);%if rr == 206 && rrr == 242
            if rr == 205 && rrr == 232
                 SoPoCalcY(kount)=LatentH(rr,rrr);
            end
             %july 2021 vector captures to add
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
           
            %july2020albuquerque vector captures
            if rr == 360 && rrr == 179
            AlbVecY(kount) = LatentH(rr,rrr);
            end
            %Fortaleza Brazil vecture captures
              if rr == 457 && rrr == 123
                  FortVecCalc2(kount) = LatentH(rr,rrr);
              end
            %Christchurch NZ vector captures NZVecCalc2
            if rr == 245 && rrr == 67
            NZVecCalc2(kount) = LatentH(rr,rrr);
            end
            %Aukland NZ vector captures AukVecCalc2
            if rr == 249 && rrr == 76
            AukVecCalc2(kount) = LatentH(rr,rrr);
            end
             if rr == 224 && rrr == 129
                 twwpCalc2 (kount)=LatentH(rr,rrr);
             end
              if rr == 224 && rrr == 160
                 bullseye2(kount)=LatentH(rr,rrr);
             end
          end
    end
    
        %Third, the North Polar strip Study Area of my interest
        for rr = 1:Longitude %loop through rows, which are longitude
         %longbox = rr - Hwiboxlongspan;
          %innerK=0;
          %rback=rr-1;
          PolarStripCalcV(kount,rr)= LatentH(rr,242);
        end  % end of dual loop to define the polar strip, which is only a test
        
           % MyCorBox  for making correlation maps
        for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude
             %MyCorBox(r,rr,rrr)= LatentH(rr,rrr);
             MyCorBox(kount,rr,rrr)= LatentH(rr,rrr);
         end
        end  % end of dual loop to define the correlation box
        
        %{
        %populating MyWindCorYBox
        for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude
             MyWindCorYBox(r,rr,rrr)= LatentH(rr,rrr);
         end
        end  % end of dual loop to define the global wind Y box, which is only a test
        %}
    %result(r) = LEDIVData(kount);
    %test = LEDIVData(:,startcol:endcol);%illegal.  must assign actual #s
                                         %instead of startcol and endcol\
   %accordingly, must build each matrix the loop way see examples below
   
  % testC = LatentH';
  %this assignment to my key "testC" worked and I made 442 plots.  now I turn off plot for other data
   %for key "testC" to be mean of any monthly span, uncomment meanLatH and testC below and comment out testC above

     myVtest = mean(LatentH); 
     myVtest2 = mean(myVtest);%this 2 step works for mean
    globalVCalc(r) = myVtest2;%when done, copy this from Variables
   end  % end of month loop
       meanLatH=meanLatHTemp/kount;
    testC = meanLatH';
 
 clear LEDIVData2;
% { 
 % special global correlation to meridional winds  need to uncomment other
% lines as well to plot
   load SSNcase5.csv % load solar for cross corr
   load ArcticSepIce.csv % load ice for cross corr
   if TrendFlag == 1
   %if rspan > 1
         for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude 
         %USE THIS!! MyCorSet = corrcoef(SSNcase5, MyCorBox(1:nsets,rr,rrr));
         %USE THIS!!MyCorArray(rr,rrr) = MyCorSet(1,2);
    %can also use  
             %MyCorSet = corrcoef(SSNcase5, MyCorBox(1:nsets,rr,rrr));
    %  MyCorSet = corrcoef(ArcticSepIce, MyCorBox(:,rr,rrr));
             %MyCorArray(rr,rrr) = MyCorSet(1,2); %key for Cor
              p=polyfit(monthVectorT,MyCorBox(:,rr,rrr),1); %key for Cor
              MyTrendArray(rr,rrr) = p(1,1);  %key for cor and trend
         end
        end  % end of dual loop for corr and trend outputs
   % end
          TrendArray=MyTrendArray';  %key for trend of course
          MyLatTrend = mean(TrendArray,2); %to get the av trend vs latitude plot
 
      
  %   testA = MyCorArray';% here for correlation array plot  key
      testA = TrendArray;% here for trend array plot    key
   end % end TrendFlag test
 %end of special global corr
   %}
 %OLD   making MyWindCorBox and associated correlation development
 %{
        for r= rbeg:rspan:rend;
         for rr = 1:512 %loop through rows, which are longitude
          for rrr = 1:256 %loop through cols which are latitude 
             MyCorWindMag(r,rr,rrr) = hypot(MyWindCorXBox(r,rr,rrr), MyWindCorYBox(r,rr,rrr));
         %MyCorArray(rr,rrr) = MyCorSet(1,2);
        end
         end  
          end
%{
% use this to test any month, replace 1 in mycorwindmag with month of choice  
       for rr = 1:512 %loop through rows, which are longitude
          for rrr = 1:256 %loop through cols which are latitude 
             MytestWindMag(rr,rrr) = MyCorWindMag(1,rr,rrr);
        end
         end  
%}
%making MyWindCorBox and associated correlation development
 
         for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude 
          MyWindCorSet = corrcoef(SSNcase5, MyCorWindMag(1:nsets,rr,rrr));
          
          MyWindCorArray(rr,rrr) = MyWindCorSet(1,2);
         %MyCorArray(rr,rrr) = corrcoef(AnimasCalc (r), LatentH(rr,rrr));
         
         end
        end  %

          for rr = 1:512 %loop through rows, which are longitude
         for rrr = 1:256 %loop through cols which are latitude 
          MyTWindCorSet = corrcoef(TWindMag, MyCorWindMag(1:nsets,rr,rrr));
          
          MyTWindCorArray(rr,rrr) = MyTWindCorSet(1,2);
         %MyCorArray(rr,rrr) = corrcoef(AnimasCalc (r), LatentH(rr,rrr));
         
         end
        end
%}
 
 %NEXT setting up all CONTOURING parameters.. Need to have built data for
%same time variables in the OTHER matlab program, and have run that,
%which is labeled "ReadingUcarAndContsCopyrightMWA20152017.m"
     %the globalMin,Max can be queried for limits to assign for contours
     %for the final set used.  but I've already calculated the min and max
     %for all sets within the main loop
     % globalMin = min(Vq);
      %globalMax = max(Vq);
       %gglobalMin = min(globalMin);
       %gglobalMax = max(globalMax);

       
     %mydiv = (gglobalMax - gglobalMin)/30; %*******generic default range slicing
     %cRangeEP = [gglobalMin : mydiv : gglobalMax]; %********generic default range


   Fc = griddedInterpolant(X, Y, testC, 'linear');%this creates the master grid for interpolating
    Vqc = Fc(Xq,Yq);  %this used master grid to reassign values to a different grid
   
     %Fa = griddedInterpolant(X, Y, testA, 'linear');%for correlation plotting
     %Vqa = Fa(Xq,Yq);  %this used master grid to reassign values to a different grid 
 
     Fz = griddedInterpolant(X, Y, testZ, 'linear');%this creates the master grid for interpolating
    Vqz = Fz(Xq,Yq);  %this used master grid to reassign values to a different grid
 %{
    %new only good for now for high res grid so off temporarily
    myAlat = Vq(147:169,263:313);
    myAlatX = Vqb(147:169,263:313);
    myAlatY = Vqc(147:169,263:313);
    myCurl = curl(myAlatX,myAlatY);
    mainCurl = curl(Vqb,Vqc);
    
           
      globalcurlMin = min(mainCurl);
      globalcurlMax = max(mainCurl);
       gglobalcurlMin = min(globalcurlMin);
       gglobalcurlMax = max(globalcurlMax);
   %}
    
    %{
       %use this for curl plots
     %pcolor (myCurl); %best 
     pcolor (mainCurl); %best 
     
           shading interp; %interp;
     colormap (flipud(cool));
    cRange = [-11000 : 500 : 105000]; %best for curl
     caxis([-11000, 10500]);%best for curl
%}
     
  %WindMag set up for true mag of vectors, and contours set for focus on
 %ITCZ band.. I'll only use once in a while so this is commented out for
 %now, but it does work
 %%{ 
 PolarAverage = mean(PolarStripCalcV,2);%interesting
%this is only hardwired for a certain grid res
%TWindMag=hypot(twwpCalc1,twwpCalc2);
 WindMag=hypot(Vqb,Vqc);
 if TrendFlag == 1
 WindTrend= hypot(TrendUArray, TrendArray);
 end %end trendflag test
 MgaWin=hypot(MyCorUBox,MyCorBox);
  MySquare = WindMag(1:64,1:64);
  %colormap (flipud(cool));
    
  %contourf(WindMag);
   %pcolor (MyWindCorArray'); %for wind correlation color field
   %contourf(MyWindCorArray'); %for wind correlation contour
    %  contourf(MyTWindCorArray'); %for wind correlation contour
    %********for CONTOURING WINDS as opposed to overlaying streamlines
   % {   
    %***************UNCOMMENT FOR PLOTTING WIND COLOR MAP
    %colormap Jet;  
    %pcolor (Vqa);  %FOR CORRELATION plot need to uncomment other lines
    %above also
    %image(WindMag);
     %pcolor (Vqc);
     colormap Jet;%Bone,Jet
    %pcolor (Vqc); %for merid wind trend
     %pcolor (WindMag); %BESTBESTBEST for primary variable wind
     if TrendFlag==1    
     pcolor (WindTrend);
     else  pcolor (WindMag);
     end  %end of trendflag test
   
   %caxis([0,4.4e5]);%cRange****USE THIS global range typically unless I want
                       %max color field intensity
  %caxis([0,3.e5]);  %best for 5yta wind?
   %   caxis([0,3.5e5]);  %BEST FOR WIND
      % caxis([-7e4,7e4]);%hopefully good for meridional winds
     colorbar;
      %image (Vq);
    shading flat; %interp %flat;
     % s.EdgeColor = 'none';
   %}************************************************************
   %{
 %MySquare = WindMag(
 MyEigen = eig(MySquare);
 MyrealEigen = real(MyEigen);
% MyDivergence = div(Vqb,Vqc);
for ar = rbeg:rspan:rend 
    SoPoCalc (ar) = hypot(SoPoCalcX(ar),SoPoCalcY(ar));
    AlbVecAll(ar) = hypot(AlbVecX(ar),AlbVecY(ar));
    FortVecCalcAll(ar) = hypot(FortVecCalc1(ar),FortVecCalc2(ar));
    NZVecCalcAll(ar) = hypot(NZVecCalc1(ar),NZVecCalc2(ar));
    AukVecCalcAll(ar) = hypot(AukVecCalc1(ar),AukVecCalc2(ar));
      %hold on;
end
      %}

%need to learn how to extract the right cells from Vqb and Vqc for my curl
%experiments
% HwipolyX2 = [263,263,312,312,263];
% HwipolyY2 = [147,169,169,147,147];
%can now contour that curl

%{
  %cRangeEP = [7.7e7:2000000:8.e7];%for Z paper
   % cRangeEP = [5.e7:2000000:8.e7];%full range for Z
 %  cRangeEP = [1000000 : 100000 : 3000000.]; %best for reg temmperaure
   cRangeEP = [-.000100:.00002:.00004];%best for EP
        %cRangeEP = [-.000600:.00002:.00003];% full rangefor EP  
     %cRangeEP = [-250: 50. : 250]; %best for LEDIV   %  
      % cRangeEP = [-900 : 50. : 400]; %fullest for LEDIV
   %   cRangeEP = [-.0003:.00002:.00004];
   %  cRangeEP = [-8000 : 500 : 4000]; %best for curl
   
  %shading flat; %flat; %interp;
 %contourf (Vq,cRangeEP,'LineWidth',.1);  %THE CONTOUR CONTROL
   

 pcolor (Vq); %best
 
 %image (Vq);
 shading interp; %interp;
%    colormap (flipud(jet));%Winter Hot Bone Jet Cool HSV%flipup reverses
%                                and note that the 1st letter is now lower
%                                case
colormap (flipud(cool));
%older best    colormap Cool;%Winter Hot Bone Jet Cool HSV
       %colormap (flipud(cool));%Winter Hot Bone Jet Cool HSV%flipup reverses
      %colormap ((bone+white)/2);%Jet Hot Winter Bone %The MASTER colorbar setting
  colorbar;
      %caxis([gglobalMin, gglobalMax]); %*********generic default
  % axis on;
 %caxis([-900,400]);%cRange fullest for LEDIV
     % caxis([-250,250]);%cRange best for LEDIV
    caxis([-.0001,0.00004]);%best for EP
    %caxis([-.0006,0.00003]);%cRange full for EP
         %caxis([7.7e7,8.e7]); %for Z paper
     %caxis([5.6e7,8.e7]); %for Z standard
  %  caxis([1000000.,3000000]);% max2004 was 525000  %best for reg temperature
          %caxis([-.0001,0.00004]);%cRangeEP best
   
    %note keep this process here just after the two main loops
   %otherwise need to set up so that the vectors and overlays aren't
   %overwritten by the contours.
%FINISHED setting up all CONTOURING 
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
   set(gca,'FontSize',14);
  end
   set(gca,'FontWeight','bold')%this worked in command line
   xticklabels({'0E','30E','60E','90E','120E','150E','180','150W','120W','90W','60W','30W','0W'});
   yticklabels({'90S','75S','60S','45S','30S','15S','0','15N','30N','45N','60N','75N','90N'});
      %hold on;
   %below was older command label approach which was superceded in matlab
   %upgrade. new has somewhat less control esp for fonts but can learn
   %later
  %set(gca,'XTickLabel','0|30E|60E|90E|120E|150E|180|150W|120W|90W|60W|30W|0','FontWeight','bold','FontSize',12);
  %set(gca,'YTickLabel','90S|75S|60S|45S|30S|15S|0|15N|30N|45N|60N|75N|90N','FontWeight','bold','FontSize',12);
 %&&&&&&&& END CONTOURING FEATURES &&&&&&&&&&&&

%note that if I want to plot arrow vectors, use this quiver command
   

mylinwid = 3 %.5;
%quiver(Vqb,Vqc,'black','LineWidth',mylinwid);%a thicker arrow
   
%quiver(Vqb,Vqc,3,'black','LineWidth',mylinwid);%has been good

%quiver(Vqb,Vqc,4,'red','LineWidth',mylinwid);%the  quiver the number in the third 
   %                                                    entry is the scale
   %   quiver3(Xq,Yq,Vq,Vqb,Vqc,Vqz,.000001);%doesn't work yet
   %htube = streamtube(Vqb,Vqc,sxRight,sy);
 
  %#########  Overlays:  mostly GRID SCALE DEPENDENT CODE below    #####################
   
   %%}
%end  % end of month loop

%surf(Vq);  %CURRENTLY OPTIMIZED FOR ITCZ SURFACE plots for my paper
     %xlim([-100,600])
    % ylim([0,300])
   % zlim([-.0004,0.0002])%%best most recent for EP surface
  %view([-7 85]);  %best  2019 prev best for surf plots for my paper  -45  67,
    %camzoom(3);
 %%{ 
%surf(Vq);
 % zlim([6.0e7 7.86e7]); 
 %various for surf plots for my paper   
 %zlim([7.7e7 8.0e7]);
  %zlim([-.0004,0.0002])%%best most recent for EP surface
  %zlim([-.0002,0.00003]);
  
%view([-45 66]);  %best for surf plots for my paper  -45  67, 
  %(0,0) gives view due north from above south pole at base level,  
  %(90,0)  %gives view due west from mid level and latitude. % 90 90 is top down
  
       % zlim([-250,250])%%best most recent for LEDIV surface
 %light('Position',[100 -520 9000000]);  %best for surf plots for my paper
        % view(-35,45);  %conventional oblique
         %view([-65.5 47]); %what I use for many
     %light('Position',[100 -20 9000000]);
    % zoom (1.8);
%}
% surf looks good, but not practical to use yet 
% surf (testB)
%zoom (1.8);

% surf(Vq);  %CURRENTLY OPTIMIZED FOR ITCZ SURFACE plots for my paper
    % zlim([7.7e7 8.e7]); %best for surf plots for my paper   
   %zlim([-.0004,0.0002])%%best most recent for EP surface
   % zlim([5.6e7 7.84e7]);  %6.e7 8.e7   for Z
    %  zlim([-250,250])%%best most recent for LEDIV surface
      %view([-0 90]);
 % view([-8 81]);  %best 2019 prev best for surf plots for my paper  -45  67, 
       %(0,0) gives view due north from above south pole at base level,  
 % view([90,0]);  %gives view due west from mid level and latitude. % 90 90 is top down
  
  
 %light('Position',[100 -520 9000000]);  %best for surf plots for my paper
        %view(-35,45);  %conventional oblique
         %view([0, 84]); %what I use for many
    % light('Position',[100 -20 9000000]); % super best?
%}
%zoom (1);
hold on;



%used to have all continents here, but no longer necessary
% {
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
load Antarctica5.csv %Needs Workchange name here as needed
LongCoord = Antarctica5(:,1);%change name here as needed
LatCoord = Antarctica5(:,2);%change name here as needed
%latdeg = 256 - (90- LatCoord)/.703125;
%longdeg = LongCoord/.703125
latdeg = rowsperSet - (90- LatCoord)/degPercolumn;
longdeg = LongCoord/degPercolumn;
plot(longdeg,latdeg,'black','LineWidth',mylinwid);
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



hold on;
     
%%{  
     %STREAMLINES BEGIN
%various origination locations
sz2 = 7.7e7;
%first the active locations for coarse grid
sx = [65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65]; %24 values
sy = [0 2.5 5 7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 42.5 35 37.5 40 42.5 45 47.5 50 52.5 55 57.5];
%sxBottom = [0.5 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230];
sxBottom = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120];   
sxBottom2 = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125]; 
sxTop = sxBottom;
%sxBottom = [0.5 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230];
sxRev1 = sxBottom * .7;  %note for later, this setup works but too many columns only need 19
%ssx = [65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65]; %24 values
%ssy = [0 2.5 5 7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 42.5 35 37.5 40 42.5 45 47.5 50 52.5 65 57.5];
%sy1 =[0.5	3	5.5	8	10.5	13	15.5	18	20.5	23	25.5	28	30.5	33	35.5	38	40.5	43	45.5	48	50.5	53	65.5	58];
sy1 = sy+ 0.5; sy2 = sy1 + .5; sy3 = sy2 + .5; sy4 = sy3 + .5; sy5 = sy4 + .5; sy6 = sy5 + .5;
%sy2 =[1	3.5	6	8.5	11	13.5	16	18.5	21	23.5	26	28.5	31	33.5	36	38.5	41	43.5	46	48.5	51	53.5	66	56.5];
%sy3 =[1.5	4	6.5	9	11.5	14	16.5	19	21.5	24	26.5	29	31.5	34	36.5	39	41.5	44	46.5	49	51.5	54	66.5	59];
%sy4 =[2	4.5	7	9.5	12	14.5	17	19.5	22	24.5	27	29.5	42	34.5	37	39.5	42	44.5	47	49.5	52	54.5	67	59.5];
syBottom = [3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73  3.73 ];
%sySubBottom = [1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1. ];%older shorter
sySupraBottom = [6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6.  6. ];
syEq = [32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.  32.];
sylat10 = [35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7  35.7 35.7];
sylatneg10 = [28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6  28.6 28.6];
sylat30 = [42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844  42.844 42.844];
sylat20 = [39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289  39.289 39.289];

sylatneg30 = [21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511  21.511 21.511];
sylat45 = [48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178  48.178 48.178];
sylatneg45 = [16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178  16.178 16.178];
sxSubBottom = [1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125]; %key soon
sySubBottom (1,:) = [1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.];%key now
%{
for r = 2:1:32
    tmin1= r-1;
    sySubBottom (r,:)= sySubBottom (tmin1,:)+ 2. ;
    sxSubBottom (r,:)= sxSubBottom (1,:);
end
%}
% {
for r = 2:1:16
    tmin1= r-1;
    sySubBottom (r,:)= sySubBottom (tmin1,:)+ 4. ;
    sxSubBottom (r,:)= sxSubBottom (1,:);
end
%}

syTop = [60.62 60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62  60.62 ];
syHiLat = 0.95*syTop;
%syTop = [57.5 57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5  57.5 ];
%syBottom1 = [5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0 5.0];
syTopper =  [62. 62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62.  62. ];
syLowTop =  [56. 56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56.  56. ];
sxAll = [85. 85. 85. 85. 85. 85. 85. 85. 85. 85. 85. 85. 85. 95. 95. 95. 95. 95. 95. 95. 95. 95. 95. 95. 95. 95.];
%needs to be cleaned up along with consistency with calculation of partner
%syAll
syAll = [30  32  34  36  38  40  42  44  46  48  50  52  54  30  32  34  36  38  40  42  44  46  48  50  52  54];%needs to be cleaned up
syEven = syAll - 20;
sxLeft = [.25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25];
%sxLeft = [.25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25 .25];
sxAsia = [42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42];
sxCent1 = sx + 5.0; sxCent2 = sxCent1 + 5.0; sxCent3 = sxCent2 + 5.0; sxCent4 = sxCent3 + 5.0; sxCent4 = sxCent3 + 5.0;  sxCent5 = sxCent4 + 5.0; sxCent6 = sxCent5 + 5.0; 
sxIndia1 = sxLeft + 27.5; sxIndia2 = sxIndia1 + 5.0; sxIndia3 = sxIndia2 + 5.0; sxIndia4 = sxIndia3 + 5.0; sxIndia4 = sxIndia3 + 5.0;  sxIndia5 = sxIndia4 + 5.0; sxIndia6 = sxIndia5 + 5.0; 
%sxLeft1 =[67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5	67.5];
%sxLeft2 =[70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70	70];
%sxLeft3 =[72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5	72.5];
%sxLeft4 =[75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75];
%sxLeft5 =[77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5	77.5];
sxRight = [128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0 128.0];
%sxRight = [100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0];
sxRight1 = sxRight + 5.; sxRight2 = sxRight1 + 5.; sxRight3 = sxRight2 + 5.; sxRight4 = sxRight3 + 5.; sxRight5 = sxRight4 + 5.; sxRight6 = sxRight5 + 5.;

fsxLandVL = [298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7 298.7];
sxLandVL = fsxLandVL * 0.703125 / 2.81255;
%{
sxRight1 = [75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0 75.0];
sxRight2 = [110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0 110.0];
sxRight3 = [115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0 115.0];
sxRight4 = [120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0 120.0];
%}

%sxRight2 = [78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25 78.25];
%sxRight1 = [76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75 76.75];
%sxRight3 = [123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5];
%sxRight4 = [100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0 100.0];
%sxRight3 = [85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00 85.00];
%sxRight6 = [75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00 75.00];
%sxRight7 = [77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5 77.5];
%sxRight8 = [80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00 80.00];
%sxRight9 = [79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00 79.00];

sxAlaska = [80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80. 80.];
sxEgyreLongline = [106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106. 106.];
sxbullseye =  [7. 20. 30. 64. 64. 7.   7.  7.  7. 52. 52.  7. 106. 106. 106. 106. 106. 106. 123.5 123.5 123.5 123.5 123.5 80.];%latest official best
sycondenstop = [65. 61. 63.  5.  7. 15. 42. 35. 56. 26.25 40. 65.  35. 40   50.  22.  26.   30.  42.5  39.   40.   41.   42.5   40.];%latest official best
fElChaconx = [381. 381. 381. 381. 381.];
fElChacony = [150. 151. 152. 153. 154.];
ElChacony = fElChacony*0.703125/2.8125;
ElChaconx = fElChaconx*0.703125/2.8125;
Pinatubox = [171. 171. 171. 171.];
Pinatuboy = [149. 149.5 150. 150.5];
%Pinatubox = fPinatubox*0.703125/2.8125;
%Pinatuboy = fPinatuboy*0.703125/2.8125;
fMtStHelensx = [338.212 338.212 338.212 338.212];
fMtStHelensy = [188. 190. 192. 194.];
fAndes1x = [413. 413. 413. 413.];
fAndes1y = [78. 79. 80. 81.];

   %Africa Study assets
   fCongox = [21.76]; fCongoy = [122.596];%Congo 
   fOkavx = [31.004]; fOkavy = [103.111]; %Okavango
   fAwashx = [54.898]; fAwashy = [141.084]; %Awash
   fOuergx = [504.875]; fOuergy = [177.948]; %Ouergha
   fGarisx = [56.462]; fGarisy = [128.071]; %Garissa
   fAswanx = [46.791]; fAswany = [162.788]; %Aswan
   fKharx = [46.293]; fKhary = [150.926]; %Khartoum
   fRosex = [48.896]; fRosey = [145.564]; %Roseires
   fNigex = [501.262]; fNigey = [147.010]; %Niger
   %OkavangoRPoint = scatter(31.004,103.111,'o','MarkerEdgeColor','k','LineWidth',1);%Botswana
   %OuerghaRPoint = scatter(504.875,177.948,'o','MarkerEdgeColor','k','LineWidth',1);%Morroco MA
   %too short recordGambellaRPoint = scatter(49.18,140.444,'o','MarkerEdgeColor','b','LineWidth',1);%Ethiopia ET
   %AwashRPoint = scatter(54.898,141.084,'o','MarkerEdgeColor','k','LineWidth',1);%Ethiopia ET
   %GarissaRPoint = scatter(56.462,128.071,'o','MarkerEdgeColor','k','LineWidth',1);% Kenya KE
   %AswanPoint = scatter(46.791,162.788,'o','MarkerEdgeColor','k','LineWidth',1);% Egypt
   %KhartoumPoint = scatter(46.293,150.926,'o','MarkerEdgeColor','k','LineWidth',1);% Sudan
  % RoseiresPoint = scatter(48.896,145.564,'o','MarkerEdgeColor','k','LineWidth',1);%Blue Nile Roseires
   %NigerPoint = scatter(501.262,147.010,'o','MarkerEdgeColor','k','LineWidth',1);%Niger at Koulikoro Mali


%next the active locations for original fine grid
fsxOLR = [257 257 257 257];
fsyOLR = [122 125 131 136];

fsxAll = sxAll*2.8125/0.703125;
fsyAll = syAll*2.8125/0.703125;

fsx = sx*2.8125/0.703125;
fsxLeft = sxLeft*2.8125/0.703125;
fsxAsia = sxAsia*2.8125/0.703125;

fsxIndia1 = sxIndia1*2.8125/0.703125;
fsxIndia2 = sxIndia2*2.8125/0.703125;
fsxIndia3 = sxIndia3*2.8125/0.703125;
fsxIndia4 = sxIndia4*2.8125/0.703125;
fsxIndia5 = sxIndia5*2.8125/0.703125;
fsxIndia6 = sxIndia6*2.8125/0.703125;

fsxCLeft1 = sxCent1*2.8125/0.703125;
fsxCLeft2 = sxCent2*2.8125/0.703125;
fsxCLeft3 = sxCent3*2.8125/0.703125;
fsxCLeft4 = sxCent4*2.8125/0.703125;
fsxCLeft5 = sxCent5*2.8125/0.703125;
fsxCLeft6 = sxCent6*2.8125/0.703125;

fsxBottom = sxBottom*2.8125/0.703125;
fsxBottom2 = sxBottom2*2.8125/0.703125;
%fsxBottom = sxRev1*2.8125/0.703125;

%{
fsxBottom2 = sxBottom2*2.8125/0.703125;
fsxBottom3 = sxBottom3*2.8125/0.703125;
fsxBottom4 = sxBottom4*2.8125/0.703125;
fsxBottom5 = sxBottom5*2.8125/0.703125;
fsxBottom6 = sxBottom6*2.8125/0.703125;
%}
fsyBottom = syBottom*2.8125/0.703125;
fsyEq = syEq*2.8125/0.703125;
fsylat10 = sylat10*2.8125/0.703125;
fsylatneg10 = sylatneg10*2.8125/0.703125;
fsylat30 = sylat30*2.8125/0.703125;
fsylat20 = sylat20*2.8125/0.703125;
fsylatneg30 = sylatneg30*2.8125/0.703125;
fsylat45 = sylat45*2.8125/0.703125;
fsylatneg45 = sylatneg45*2.8125/0.703125;

fsySubBottom = sySubBottom*2.8125/0.703125;%key now
fsxSubBottom = sxSubBottom*2.8125/0.703125;%key now
fsySupraBottom = sySupraBottom*2.8125/0.703125;
fsxTop = fsxBottom;  fsxEq = fsxBottom2;
fsyTop = syTop*2.8125/0.703125;
fsyHiLat = syHiLat*2.8125/0.703125;
fsyLowTop = syLowTop*2.8125/0.703125;
fsyTopper = syTopper*2.8125/0.703125;

%{
 fsyBottom2 = syBottom2*2.8125/0.703125;
fsyBottom3 = syBottom3*2.8125/0.703125;
fsyBottom4 = syBottom4*2.8125/0.703125;
fsyBottom5 = syBottom5*2.8125/0.703125;
fsyBottom6 = syBottom6*2.8125/0.703125;
%}

%fsxLandVL = sxLandVL*2.8125/0.703125;

fsxRight = sxRight*2.8125/0.703125;
fsxRight1 = sxRight1*2.8125/0.703125;
fsxRight2 = sxRight2*2.8125/0.703125;
fsxRight3 = sxRight3*2.8125/0.703125;
fsxRight4 = sxRight4*2.8125/0.703125;
fsxRight5 = sxRight5*2.8125/0.703125;
fsxRight6 = sxRight6*2.8125/0.703125;

fsy = sy*2.8125/0.703125;
fsy1 = sy1*2.8125/0.703125;
fsy2 = sy2*2.8125/0.703125;
fsy3 = sy3*2.8125/0.703125;
fsy4 = sy4*2.8125/0.703125;
fsy5 = sy5*2.8125/0.703125;
fsy6 = sy6*2.8125/0.703125;

%fsx = ssx*2.8125/0.703125;
%fsy = sy*2.8125/0.703125;
%fsxLeft = sxLeft*2.8125/0.703125;
%fsxRight = sxRight*2.8125/0.703125;

fsxAlaska = sxAlaska*2.8125/0.703125;
fsxEgyreLongline = sxEgyreLongline*2.8125/0.703125;
fsxbullseye = sxbullseye*2.8125/0.703125;
fsycondenstop = sycondenstop*2.8125/0.703125;

%all below sets currently inactive
sxPartDemoA = [42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42. 42.];
sxEgyreLongline2 = [102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102. 102.];%custom for N Atlantic gyre
sycondens = [0 2.5 5 7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 42.5 35 37.5 40 42.5 45 47.5 50 52.5 65 57.5];
sycondenstopE= [22 23 24 25 26 27 28 29 30 31 42.5 33 34 35 36 37 39 40 41 42.5 43 45 47.5 50];
syRight = sy;
sxCentral = [96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96. 96.];
sxCentral3 = [82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82. 82.];
%sxAll = [2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 123.5 123.5 123.5 123.5 123.5 123.5 123.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5];
sz = sz2;
sxZebra = [65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5 65 123.5];

%OLRX=[56.889,71.111];
 %  OLRY=[42.178,42.178];

%{
hold off on commenting out
%*****invoke streamlines here
if GridScale == 2 % i.e. coarse
   
    %later I set testAll = stream2(Vqb,Vqc,fsxAll,fsyAll);
      % later I set testRight = stream2(Vqb,Vqc,fsxRight1,fsy);
 %{
      plot(sxAll,syAll, '*w');
   hAll = streamline(Vqb,Vqc,sxAll,syAll);
   set(hAll,'Color','white');
   set(hAll,'LineWidth',.5);
%}   
% later I set testTop = stream2(Vqb,
         plot(sxRight1,sy, '*w');
     hright = streamline(Vqb,Vqc,sxRight1,sy);
   set(hright,'Color','magenta');
   set(hright,'LineWidth',.5);
   % later I set testTop = stream2(Vqb,Vqc,fsxTop,fsyTop);
         plot(sxTop,syTop, '*w');
   hTop1 = streamline(Vqb,Vqc,sxTop,syTop);
   set(hTop1,'Color','white');
   set(hTop1,'LineWidth',0.5);
   % later I set testBottom = stream2(Vqb,Vqc,fsxBottom,fsyBottom);
      plot(sxBottom,syBottom, '*w');
      hBottom1 = streamline(Vqb,Vqc,sxBottom,syBottom);
   set(hBottom1,'Color','white');
   set(hBottom1,'LineWidth',0.5);
   % later I set testleft = stream2(Vqb,Vqc,fsxLeft,fsy); 
      plot(sxLeft,sy, '*w');
       hleft = streamline(Vqb,Vqc,sxLeft,sy);
   set(hleft,'Color','blue');
   set(hleft,'LineWidth',0.5);
   % later I set testLandVL = stream2(Vqb,Vqc,fsxLandVL,fsy);
        plot(sxLandVL,sy, '*w');
       hLandVL = streamline(Vqb,Vqc,sxLandVL,sy);
   set(hLandVL,'Color','green');%mostly use yellow here
   set(hLandVL,'LineWidth',0.5);
   
   %hcenter = streamline(Vqb,Vqc,sx,sy);
   %set(hcenter,'Color','blue');
   
  % h = streamline(Vqb,Vqc,sxLeft,sy);
   %set(h,'Color','red');

   %hrighto = streamline(Vqb,Vqc,sxRight,sy);
   %set(hrighto,'Color','green');
   %set(hrighto,'LineWidth',3.5);
   
  % hAlaska = streamline(Vqb,Vqc,sxAlaska,sy);
   %set(hAlaska,'Color','black');
   %set(hAlaska,'LineWidth',.5);
   
 %  hcentral2 = streamline(Vqb,Vqc,sxEgyreLongline,sy);
  % set(hcentral2,'Color','green'); %yellow,magenta,cyan,red,green,blue,white,black

  % hElChacon = streamline(Vqb,Vqc,ElChaconx,ElChacony);
  % set(hElChacon,'Color','white');
   
  % hPinatubo = streamline(Vqb,Vqc,Pinatubox,Pinatuboy);
  % set(hPinatubo,'Color','yellow');

elseif GridScale ==1;  % i.e. original fine
    
      %large grid for all streamlines new default
      %plot(fsxSubBottom,fsySubBottom, '*w');%use to place star at origin
     hBottom1 = streamline(Vqb,Vqc,fsxSubBottom,fsySubBottom);
 set(hBottom1,'Color','white');
 %set(hBottom1,'LineWidth',0.5);
   
  %  later I set testAll = stream2(Vqb,Vqc,fsxAll,fsyAll);
end
 %}
   % hcentral3 = streamline(Vqb,Vqc,sxCentral3,sycondens);
    % set(hcentral3,'Color','magenta');


    %*****invoke stream2 objects here
 if GridScale == 2 % i.e. COARSE again
      %testAll = streamline(Vqb,Vqc,sxAll,syAll); 
 testleft = streamline(Vqb,Vqc,sxbullseye,sycondenstop);%best overall
 %testright = stream2(Vqb,Vqc,sxRight,sy);
 testbullseye = streamline(Vqb,Vqc,sxbullseye,sycondens);

 elseif GridScale ==1  % i.e. original FINE again
 %testleft = stream2(Vqb,Vqc,fsxbullseye,fsycondenstop);%best overall
 %testright = stream2(Vqb,Vqc,fsxRight,fsy);
 %testbullseye = stream2(Vqb,Vqc,fsxbullseye,fsycondenstop);

 % {
     % hBottom1 = streamline(Vqb,Vqc,fsxSubBottom,fsySubBottom);
 %set(hBottom1,'Color','white');
 %set(hBottom1,'LineWidth',0.5);
 % testAll = streamline(Vqb,Vqc,fsxAll,fsyAll); % this is the OTHER DEFAULT
  %set(testAll,'Color','white');
  %{ 
     % a sparse but broad coverage
    testRight = streamline(Vqb,Vqc,fsxRight1,fsy);
    testTop = streamline(Vqb,Vqc,fsxTop,fsyTop);
    testBottom = streamline(Vqb,Vqc,fsxBottom,fsyBottom);
    
    testLandVL = streamline(Vqb,Vqc,fsxLandVL,fsy);
    testleft = streamline(Vqb,Vqc,fsxLeft,fsy); 
     set(testRight,'Color','red');set(testTop,'Color','white');set(testBottom,'Color','white');
    set(testLandVL,'Color','yellow');set(testleft,'Color','white'); set(testLandVL,'LineWidth',1.5);
  %}
% testLeft = streamline(Vqb,Vqc,fsxLeft,fsylat10); set(testlat10,'Color','yellow');
 % hPinatubo = streamline(Vqb,Vqc,Pinatubox,Pinatuboy); set(hPinatubo,'Color','yellow');
 %TrendUArray, TrendArray);
testleft = streamline(Vqb,Vqc,fsxLeft,fsy); set(testleft,'Color','black');set(testleft,'LineWidth',1.);
 % testleft = streamline(TrendUArray, TrendArray,fsxLeft,fsy); set(testleft,'Color','black');set(testleft,'LineWidth',1.);
    %testleft = streamline(Vqb,Vqc,fsxLeft,fsy); set(testleft,'Color','magenta');set(testleft,'LineWidth',1.5);
%best right 
testRight = streamline(Vqb,Vqc,fsxRight,fsy); set(testRight,'Color','red');set(testRight,'LineWidth',1.);
    %testRight = streamline(TrendUArray, TrendArray,fsxRight,fsy); set(testRight,'Color','red');set(testRight,'LineWidth',1.5);
  %Congo = streamline(Vqb,Vqc,fCongox,fCongoy); set(Congo,'Color','yellow');set(Congo,'LineWidth',1.5);
  %Okav = streamline(Vqb,Vqc,fOkavx,fOkavy); set(Okav,'Color','yellow');set(Okav,'LineWidth',1.5);
  %Awash = streamline(Vqb,Vqc,fAwashx,fAwashy); set(Awash,'Color','yellow');set(Awash,'LineWidth',1.5);
  %Ouerg = streamline(Vqb,Vqc,fOuergx,fOuergy); set(Ouerg,'Color','yellow');set(Ouerg,'LineWidth',1.5);
  %Garis = streamline(Vqb,Vqc,fGarisx,fGarisy); set(Garis,'Color','yellow');set(Garis,'LineWidth',1.5);
  %Aswan = streamline(Vqb,Vqc,fAswanx,fAswany); set(Aswan,'Color','yellow');set(Aswan,'LineWidth',1.5);
  %Khar = streamline(Vqb,Vqc,fKharx,fKhary); set(Khar,'Color','yellow');set(Khar,'LineWidth',1.5);
  %Rose = streamline(Vqb,Vqc,fRosex,fRosey); set(Rose,'Color','yellow');set(Rose,'LineWidth',1.5);
  %Nige = streamline(Vqb,Vqc,fNigex,fNigey); set(Nige,'Color','yellow');set(Nige,'LineWidth',1.5);
  %{
  testEq = streamline(Vqb,Vqc,fsxEq,fsyEq); set(testEq,'Color','white'); set(testEq,'LineWidth',1.5);
  testlat10 = streamline(Vqb,Vqc,fsxEq,fsylat10); set(testlat10,'Color','yellow');
  testlatneg10 = streamline(Vqb,Vqc,fsxEq,fsylatneg10); set(testlatneg10,'Color','magenta');
    testlat20 = streamline(Vqb,Vqc,fsxEq,fsylat20); set(testlat20,'Color','red');
  testlat30 = streamline(Vqb,Vqc,fsxEq,fsylat30); set(testlat30,'Color','black');  set(testlat30,'LineWidth',0.5);
  testlatneg30 = streamline(Vqb,Vqc,fsxEq,fsylatneg30); set(testlatneg30,'Color','black'); 
  testlat45 = streamline(Vqb,Vqc,fsxEq,fsylat45); set(testlat45,'Color','cyan');  set(testlat45,'LineWidth',0.5);
  testlatneg45 = streamline(Vqb,Vqc,fsxEq,fsylatneg45); set(testlatneg45,'Color','cyan'); 
  %}
    pollarX=[0.,512.];
   pollarY=[242.48,242.48];
   pollantY=[14.933,14.933];
   pollarline=plot(pollarX,pollarY,'white','LineWidth',.5);
   pollantline=plot(pollarX,pollantY,'white','LineWidth',.5);
   
testTop = streamline(Vqb,Vqc,fsxTop,fsyTop);set(testTop,'Color','white');set(testTop,'LineWidth',1.5);
testBottom = streamline(Vqb,Vqc,fsxBottom,fsyBottom);set(testBottom,'Color','white');set(testBottom,'LineWidth',1.);
     % testTop = streamline(TrendUArray, TrendArray,fsxTop,fsyTop);set(testTop,'Color','yellow');set(testleft,'LineWidth',.1);
     % testBottom = streamline(TrendUArray, TrendArray,fsxBottom,fsyBottom);set(testBottom,'Color','magenta');set(testleft,'LineWidth',.1);

 end
stableYtop = 242.8; stableXtop = 40.; 
stabstream = streamline(Vqb,Vqc,stableXtop,stableYtop);set(stabstream,'Color','green');set(stabstream,'LineWidth',2.);
 
%    testleft = stream2(Vqb,Vqc,sxAll,sy);
 %testleft = stream2(Vqb,Vqc,sxPartDemoA,sycondens);%best for left
 %gyres
 %testleft = stream2(Vqb,Vqc,sxRight,sxEgyreLongline2);%best for right gyre
 %testleft = stream2(Vqb,Vqc,sxRight,sycondens);%best for right gyre
%bestest       testleft = stream2(Vqb,Vqc,sxbullseye,sycondenstopE);%
 % testleft = stream2(Vqb,Vqc,sx,sycondens);%
 %testbullseye = stream2(Vqb,Vqc,sxbullseye,sycondens);
 
%Original STREAMLINES END
     %}
%Butterfly STREAMLINES BEGIN

sxConfederate =  [7. 20. 30. 64. 64. 7.   7.  7.  7. 7. 7. 7.];%latest official best
syConfederate = [65. 61. 63.  5.  7. 15. 42. 35. 56. 26.25 40. 65.];%latest official best

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
 
 HwipolyX2 = [263,263,312,312,263];
 HwipolyY2 = [147,169,169,147,147];
% UhpolyX2 = [355,355,363,363,355];
% UhpolyY2 = [183,176,176,183,183];
% WwipolyCenX = [223,223,225,225,223];
% HwipolyCenY = [130,128,128,130,130];
 
 

%  GpolyX2 = [365,365,363,363,365];
% GpolyY2 = [183,176,176,183,183];
 TpolyCenX = [223,223,225,225,223];
 TpolyCenY = [130,128,128,130,130];
   
    ColoradoX =[357,357,364,364,357];
  ColoradoY =[187,181,181,187,187];
  
 % ColoDry5yta = scatter(362,184);
  % PnPpoint= scatter(361.696,179.496,4,'x','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',3);
  % Animaspoint= scatter(356.113,180.939);
   %Gilapoint= scatter(357.636,175.742);

  
 %  SETTINGS FOR COARSE grid for plotting only when COARSE grid is used.
   TcpolyX2=[48,48,64,64,48];
   TcpolyY2=[34,30,30,34,34];
   UcpolyX2=[89,89,91,91,89];
   UcpolyY2=[46,44,44,46,46];
   
%  ColoDryPoint= scatter(362,185,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);
   
if GridScale == 2 % i.e. coarse
    
  %  twwpCoarsePatch=plot(TcpolyX2,TcpolyY2,'LineWidth',mylinwid);
    %TWWPcenterPoint= scatter(56.,42.,4,'MarkerEdgeColor','g','MarkerFaceColor','g')
    %urgwCoarsePatch=plot(UcpolyX2,UcpolyY2,'LineWidth',mylinwid);
 %  PnPpoint= scatter(90.424,44.874,'o','MarkerEdgeColor','g','MarkerFaceColor','b','LineWidth',mylinwid);
  % Animaspoint= scatter(89.528,45.235,'o','MarkerEdgeColor','g','MarkerFaceColor','b','LineWidth',mylinwid);
   %Gilapoint= scatter(89.409,43.933,'o','MarkerEdgeColor','g','MarkerFaceColor','b','LineWidth',mylinwid);
      GSLpoint= scatter(88.102,46.660,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);
         PnPpoint= scatter(90.424,44.874,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);
   Animaspoint= scatter(89.528,45.235,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);
   Gilapoint= scatter(89.409,43.933,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);

   OLRX=[56.889,71.111];
   OLRY=[42.178,42.178];
  % OLRline=plot(OLRX,OLRY,'red','LineWidth',mylinwid);
     %{
      GSLpoint= scatter(88.102,46.660,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   LFUTpoint= scatter(88.702,46.616,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
 % BioBiopoint=scatter(102.222,19.082,'o','MarkerEdgeColor','k','MarkerFaceColor','w','LineWidth',mylinwid);
   BioBiopoint=scatter(102.222,19.082,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
      Bithurpoint= scatter(28.542,41.641,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
%   Bithurpoint= scatter(28.542,41.641,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);
   LAndvLpoint= scatter(74.667,42.84,'o','MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',mylinwid);
   Tahitipoint= scatter(74.880,25.884,4,'o','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',mylinwid);
   %Charlestonpoint= scatter(99.58,43.83,4,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',mylinwid);
   %}
      LFUTpoint= scatter(88.702,46.616,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
    GyrePoint = scatter(65,39,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   % BioBiopoint=scatter(102.222,19.082,'o','MarkerEdgeColor','k','MarkerFaceColor','w','LineWidth',mylinwid);
   BioBiopoint=scatter(102.222,19.082,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
   Bithurpoint= scatter(28.542,41.641,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   LAndvLpoint= scatter(74.667,42.84,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   Tahitipoint= scatter(74.880,25.884,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
  % Charlestonpoint= scatter(99.58,43.83,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   

   
elseif GridScale == 1   %i.e. original fine
   %  ColoradoFinePatch=plot(ColoradoX,ColoradoY,'MarkerEdgeColor','k','LineWidth',mylinwid);
   mylinwidPatch = .5;
     twwpPatch2 = plot(TpolyX2,TpolyY2,'LineWidth',mylinwidPatch);
     HwiPatch2 = plot ( HwipolyX2,HwipolyY2,'LineWidth',mylinwidPatch);
    %normally I do use the two patches above.  took out for paper
     %twwpCenPatch = plot(TpolyCenX,TpolyCenY);
    %urgwPatch = plot(UpolyX2,UpolyY2,'LineWidth',mylinwid);
    %{
   TCAZpoint= scatter(353.702716,177.0382222,10,'r');
   SRWIDpoint= scatter(345.6272593,191.6381235,10,'r');
   SFKRCApoint= scatter(343.9420494,179.5377778,10,'r');
   RRORpoint= scatter(337.9318518,189.4518518,10,'r');
   OtowiNMpoint= scatter(361.0418569,179.7426222,10,'r');
   NRCOpoint= scatter(360.2646913,181.4546173,10,'r');
   GRGUTpoint= scatter(365.3414,184.15802,10,'r');
   CRNMpoint= scatter(363.65042,179.42021,10,'r');
   BRNMpoint= scatter(363.87292,174.54804,10,'r');
   AkRpoint= scatter(362.30163,183.37264,10,'r');
   
    
  % PnPpoint= scatter(361.696,179.496,'o','MarkerEdgeColor','g','MarkerFaceColor','b','LineWidth',mylinwid);
  % Animaspoint= scatter(356.113,180.939,'o','MarkerEdgeColor','g','MarkerFaceColor','b','LineWidth',mylinwid);
  % Gilapoint= scatter(357.636,175.742,'o','MarkerEdgeColor','g','MarkerFaceColor','b','LineWidth',mylinwid);
  
   PnPpoint= scatter(361.696,179.496,15,'b','fill');
   Animaspoint= scatter(356.113,180.939,15,'b','fill');
   Gilapoint= scatter(357.636,175.742,15,'b','fill');
    
   OLRX=[227.656,284.444];
   OLRY=[128.711,128.711];
   OLRline=plot(OLRX,OLRY,'red','LineWidth',mylinwid);
   Bithurpoint= scatter(114.168,166.566,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   BioBiopoint=scatter(408.889,76.330,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
  % Bithurpoint= scatter(114.168,166.566,12,'b','fill');
  % BioBiopoint=scatter(408.889,76.330,12,'b','fill');
   %LAndvLpoint= scatter(298.667,171.378,12,'b','fill');
   %Tahitipoint= scatter(299.52,103.5378,12,'b','fill');
   %Charlestonpoint=scatter(398.420,175.426,10,'r');    %use for finer original grid
      LFUTpoint= scatter(354.807,186.463,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
         LAndvLpoint= scatter(298.667,171.378,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   Tahitipoint= scatter(299.52,103.5378,'o','MarkerEdgeColor','m','LineWidth',mylinwid);;
       GyrePoint = scatter(220.4,157.1,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
          
      PnPpoint= scatter(361.696,179.496,'o','MarkerFaceColor','b','LineWidth',mylinwid);
   Animaspoint= scatter(356.113,180.939,'o','MarkerFaceColor','b','LineWidth',mylinwid);
   Gilapoint= scatter(357.636,175.742,'o','MarkerFaceColor','b','LineWidth',mylinwid);
   %}
  %{  
         
      OLRX=[227.556,284.444];
   OLRY=[128.00,128.00];
   %{00
   OLRline=plot(OLRX,OLRY,'red','LineWidth',mylinwid);
      Bithurpoint= scatter(114.168,165.854,'o','MarkerEdgeColor','b','LineWidth',mylinwid);
   BioBiopoint=scatter(408.889,75.619,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
   %  LFRUTpoint= scatter(354.807,185.752,'o','MarkerEdgeColor','b','LineWidth',mylinwid)
      LAndvLpoint= scatter(298.667,170.667,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
   Tahitipoint= scatter(299.52,102.827,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
   GSLpoint= scatter(352.408,186.640,10,'r');
   GyrePoint = scatter(220.4,156.444,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
      PnPpoint= scatter(361.696,178.785,'o','MarkerFaceColor','b','LineWidth',mylinwid);
   Animaspoint= scatter(356.113,180.228,'o','MarkerFaceColor','b','LineWidth',mylinwid);
   Gilapoint= scatter(357.636,175.021,'o','MarkerFaceColor','b','LineWidth',mylinwid);
  % Gilapoint= scatter(357.636,175.021,'o','MarkerFaceColor','b','MarkerEdgeColor','b','LineWidth',mylinwid);  
    AlwaysWetPoint= scatter(294.,156.,'o','MarkerEdgeColor','g','LineWidth',mylinwid);
       GSLpoint= scatter(352.408,186.640,10,'r');
       DHpoint= scatter(346.609,180.516,10,'r');
       Chicagopoint= scatter(387.31,188.271,10,'r');   
   ColoradoFinePatch=plot(ColoradoX,ColoradoY,'MarkerEdgeColor','k','LineWidth',mylinwid);
%}

end
%{   
%if I ever reopen this must make consistent with the primary matlab file,
which I've updated for the new axes settings
  if GridScale == 2
   %set(gca,'ZDir','reverse')%FOR ep ONLY
   set(gca,'XTick',[(0:10.666667:128)]);
   set(gca,'YTick',[(0:5.333333:64)]);

  elseif GridScale == 3
  % set(gca,'ZDir','reverse')%FOR ep ONLY
   set(gca,'XTick',[(0:5.333333:64)]);
   set(gca,'YTick',[(0:2.666667:42)]);
  else %when GridScale is equal to 1, the default
   %set(gca,'ZDir','reverse')%FOR EP onLY
   set(gca,'XTick',[(0:42.666667:512)]);
   set(gca,'YTick',[(0:21.333333:256)]);

  end
  set(gca,'XTickLabel','0E|30E|60E|90E|120E|150E|180|150W|120W|90W|60W|30W|0W','FontWeight','bold','FontSize',14);
  set(gca,'YTickLabel','90S|75S|60S|45S|30S|15S|0|15N|30N|45N|60N|75N|90N','FontWeight','bold','FontSize',14);
%}

%Butterfly STREAMLINES END

%{
  %cRangeEP = [7.7e7:2000000:8.e7];%for Z paper
   % cRangeEP = [5.e7:2000000:8.e7];%full range for Z
 %  cRangeEP = [1000000 : 100000 : 3000000.]; %best for reg temmperaure
   cRangeEP = [-.000100:.00002:.00004];%best for EP
        %cRangeEP = [-.000600:.00002:.00003];% full rangefor EP  
     %cRangeEP = [-250: 50. : 250]; %best for LEDIV   %  
      % cRangeEP = [-900 : 50. : 400]; %fullest for LEDIV
   %   cRangeEP = [-.0003:.00002:.00004];
   %  cRangeEP = [-8000 : 500 : 4000]; %best for curl
   
  %shading flat; %flat; %interp;
 %contourf (Vq,cRangeEP,'LineWidth',.1);  %THE COUNTOUR CONTROL
   

 pcolor (Vq); %best
 
 %image (Vq);
 shading interp; %interp;
%    colormap (flipud(jet));%Winter Hot Bone Jet Cool HSV%flipup reverses
%                                and note that the 1st letter is now lower
%                                case
colormap (flipud(cool));
%older best    colormap Cool;%Winter Hot Bone Jet Cool HSV
       %colormap (flipud(cool));%Winter Hot Bone Jet Cool HSV%flipup reverses
      %colormap ((bone+white)/2);%Jet Hot Winter Bone %The MASTER colorbar setting
  colorbar;
      %caxis([gglobalMin, gglobalMax]); %*********generic default
  % axis on;
 %caxis([-900,400]);%cRange fullest for LEDIV
     % caxis([-250,250]);%cRange best for LEDIV
    caxis([-.0001,0.00004]);%best for EP
    %caxis([-.0006,0.00003]);%cRange full for EP
         %caxis([7.7e7,8.e7]); %for Z paper
     %caxis([5.6e7,8.e7]); %for Z standard
  %  caxis([1000000.,3000000]);% max2004 was 525000  %best for reg temperature
          %caxis([-.0001,0.00004]);%cRangeEP best
   
    %note keep this process here just after the two main loops
   %otherwise need to set up so that the vectors and overlays aren't
   %overwritten by the contours.
%FINISHED setting up all CONTOURING 
 %}
    %}hold off on commenting streamlines out
    
mylinwid = 3;

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
    %{
 %  ColoradoFinePatch=plot(ColoradoX,ColoradoY,'MarkerEdgeColor','k','LineWidth',mylinwid);
    %PnPpoint = scatter(361.696,179.496, 15,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
    %Gilapoint= scatter(357.636,175.732,15,'o','MarkerEdgeColor','m','LineWidth',mylinwid);
    twwpPatch2 = plot(TpolyX2,TpolyY2,'LineWidth',mylinwid);
    HwiPatch2 = plot ( HwipolyX2,HwipolyY2,'LineWidth',mylinwid);
    %TahitiPoint = scatter(299.216,103.757,'LineWidth',mylinwid);
    %twwpCenPatch = plot(TpolyCenX,TpolyCenY);
    %urgwPatch = plot(UpolyX2,UpolyY2,'LineWidth',1);
    % WHAT IS THIS??{    249 && rrr == 76
   Aukland= scatter(249,76,'o','MarkerEdgeColor','y','LineWidth',1); 
   Jacobschaven=scatter(438.5,225.7,'o','MarkerEdgeColor','y','LineWidth',1);
   NWGreen=scatter(432.,240.,'o','MarkerEdgeColor','y','LineWidth',1);
      NEGreen=scatter(467.,236.,'o','MarkerEdgeColor','y','LineWidth',1);
         SEGreen=scatter(456.,223.,'o','MarkerEdgeColor','y','LineWidth',1);
   TCAZpoint= scatter(353.702716,177.0382222,10,'k');
   SRWIDpoint= scatter(345.6272593,191.6381235,10,'k');
   SFKRCApoint= scatter(343.9320494,179.5377778,10,'k');
   RRORpoint= scatter(337.9318518,189.4518518,10,'k');

   NRCOpoint= scatter(360.2646913,181.4546173,10,'k');
   GRGUTpoint= scatter(355.3414,184.15802,10,'k');
   CRNMpoint= scatter(363.55042,179.42021,10,'k');
   BRNMpoint= scatter(363.87292,174.54804,10,'k');
   AkRpoint= scatter(362.30163,182.662,10,'k');%corrected
   GSLpoint= scatter(352.408,185.929,10,'k');%corrected
   %Glacier National Park (GNP)
    GNPpoint = scatter(350.141,197.257,10,'b');%corrected
   %San Juan Mtns (silverton, CO) point
    SJMpoint = scatter(358.879,181.821,10,'w');%corrected
   OtowiNMpoint= scatter(361.0418569,179.022,10,'k');
   AlbuquerqueNMpoint= scatter(360.,178.6,5,'y');
   PnPpoint= scatter(361.696,178.785,'o','MarkerEdgeColor','k','LineWidth',1);%corrected
   Animaspoint= scatter(358.113,180.228,'o','MarkerEdgeColor','k','LineWidth',1);%corrected
   Gilapoint= scatter(357.636,175.021,'o','MarkerEdgeColor','k','LineWidth',1);%corrected
   %Antarctica assets
   SouthPolePoint = scatter(001.,001.,'o','MarkerEdgeColor','y','LineWidth',1);%
   DomeAPoint = scatter(110.033, 13.701,'o','MarkerEdgeColor','y','LineWidth',1);
   DomeCPoint = scatter(175.502,21.191,'o','MarkerEdgeColor','y','LineWidth',1);%
   TaylorDomePoint = scatter(225.730,17.351,'o','MarkerEdgeColor','y','LineWidth',1);%
   VostokPoint = scatter(151.988,16.403,'o','MarkerEdgeColor','y','LineWidth',1);%
   LawDomePoint = scatter(160.474,33.090,'o','MarkerEdgeColor','y','LineWidth',1);%
   SipleStationPoint = scatter(119.348,20.030,'o','MarkerEdgeColor','y','LineWidth',1);%
   


   %Africa Study assets
   CongoRPoint = scatter(21.76,122.596,'o','MarkerEdgeColor','k','LineWidth',1);%Congo
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
   FortalezaPoint = scatter(457.206,123.402,'o','MarkerEdgeColor','k','LineWidth',2);%
   ParanPosadPoint = scatter(432.526,89.785,'o','MarkerEdgeColor','r','LineWidth',1);%
   BanabuiuPoint = scatter(455.991,120.754,'o','MarkerEdgeColor','b','LineWidth',1);%
   AcarauPoint = scatter(454.613,123.477,'o','MarkerEdgeColor','r','LineWidth',1);%   
   JaguaribePoint = scatter(456.107,119.656,'o','MarkerEdgeColor','r','LineWidth',1);%
   MataderoPoint = scatter(399.692,124.599,'o','MarkerEdgeColor','y','LineWidth',1);%   
   % }  
   OLRX=[227.556,284.444];
   OLRY=[128.00,128.00];
  OLRline=plot(OLRX,OLRY,'red','LineWidth',mylinwid);
   Bithurpoint= scatter(114.168,165.854,'o','MarkerEdgeColor','k','LineWidth',mylinwid);%corrected
   BioBiopoint=scatter(408.889,75.619,'o','MarkerEdgeColor','k','LineWidth',mylinwid);%corrected
   LAndvLpoint= scatter(298.667,170.667,'o','MarkerEdgeColor','k','LineWidth',mylinwid);%corrected
   Tahitipoint= scatter(299.52,103.046,'o','MarkerEdgeColor','k','LineWidth',mylinwid);%corrected
   GyrePoint = scatter(220.4,156.444,'o','MarkerEdgeColor','k','LineWidth',mylinwid);%corrected
   AlwaysWetPoint= scatter(294.,158.,'o','MarkerEdgeColor','k','LineWidth',mylinwid);
%}
    %use for finer original grid
    
%PolarStudy assets
KamchatkaSwirlPoint = scatter(205,232.1,'o','MarkerEdgeColor','g','LineWidth',1);%
    
%PollenStudy assets   
WuhanPoint = scatter(162.595,172.293,'o','MarkerEdgeColor','m','LineWidth',1);%
SingaporePoint = scatter(147.701,130.546,'o','MarkerEdgeColor','y','LineWidth',1);%
%GuamPoint = scatter(205.929,147.832,'o','MarkerEdgeColor','y','LineWidth',1);%
%Aukland = scatter(248.551,76.305,'o','MarkerEdgeColor','m','LineWidth',1);%
SeoulPoint = scatter(180.612,182.135,'o','MarkerEdgeColor','m','LineWidth',1);%
SNSpain = scatter(507.330,181.570,'o','MarkerEdgeColor','m','LineWidth',1);%
%Christchurch = scatter(245.519,66.799,'o','MarkerEdgeColor','m','LineWidth',1);%
FortalezaPoint = scatter(457.206,123.402,'o','MarkerEdgeColor','w','LineWidth',1);%
RioDJPoint = scatter(450.599,95.133,'o','MarkerEdgeColor','w','LineWidth',1);%
%AlbuquerqueNMpoint= scatter(360.,178.6,'o','MarkerEdgeColor','k','LineWidth',2);%
NMcenterpoint= scatter(361.216,177.503,'+','MarkerEdgeColor','r','LineWidth',2);%
TXcenterpoint= scatter(369.778,172.800,'+','MarkerEdgeColor','r','LineWidth',2);%
LAcenterpoint= scatter(380.687,171.935,'+','MarkerEdgeColor','r','LineWidth',2);%
MScenterpoint= scatter(384.000,175.644,'+','MarkerEdgeColor','r','LineWidth',2);%
%ALcenterpoint= scatter(388.406,174.675,'+','MarkerEdgeColor','r','LineWidth',2);%
ALcenterpoint= scatter(388.406,175.675,'+','MarkerEdgeColor','r','LineWidth',2);%
FLcenterpoint= scatter(395.719,168.525,'+','MarkerEdgeColor','r','LineWidth',2);%
%FLcenterpoint= scatter(397,166.525,'+','MarkerEdgeColor','r','LineWidth',2);%

MTcenterpoint= scatter(356.219,195.506,'+','MarkerEdgeColor','b','LineWidth',2);%
NDcenterpoint= scatter(369.156,196.481,'+','MarkerEdgeColor','b','LineWidth',2);%
MNcenterpoint= scatter(377.406,194.691,'+','MarkerEdgeColor','b','LineWidth',2);%
VTcenterpoint= scatter(408.604,191.289,'+','MarkerEdgeColor','b','LineWidth',2);%
NHcenterpoint= scatter(410.311,191.289,'+','MarkerEdgeColor','b','LineWidth',2);%
MEcenterpoint= scatter(413.906,193.234,'+','MarkerEdgeColor','b','LineWidth',2);%


end


% NOTE!!  I can set all 'plot' commands to 'fill' for continents  
% for a specific purpose.  when done must change back
% and change the 'yellow' lines back to black

%()()()()()()()()  Print headers and files  BEGIN ()()()()()()()()()()()() 
PrintSpan = num2str(rspan);
PrintYear = num2str(myYear);
PrintMonth = num2str(myMonth);
PrintBegYear = num2str(myBegYear);
PrintEndYear = num2str(myEndYear);
PrintGridScale = num2str(degPercolumn);
TitleYearBanner = strcat(PrintBegYear,'-to-',PrintEndYear,'-at-',PrintSpan,' mo increments');
  %latest greatest outside of multi loop    

%********temporarily commenting out title for porting images to a document
% {
if TrendFlag ==1
 title({['UCAR wind trend magnitude (color map) Wind trend vectors kg/(m*s)/month and/or Wind Trend Streamlines'] ...
      [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 12); 
else
     title({['UCAR wind magnitude (color map) Wind vectors kg/(m*s)and/or Wind Streamlines'] ...
      [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 12); 
end
%}
%******
%{
tf = strcmp(myChoice,'Z');
if tf==1
  title({['ERAI fat GEOPOTENTIAL HEIGHT (Z) KG/M  Streamlines based on U,V'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end

tf = strcmp(myChoice,'T');
if tf==1
  title({['ERAI fat TEMPERATURE KG/M^2  Streamlines based on U,V'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end

tf = strcmp(myChoice,'EP');
if tf==1
  title({['ERAI fat EVAPORATION - PRECIPITATION (EP)MM/DAY  Streamlines based on U,V'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end

tf = strcmp(myChoice,'LEDIV');
if tf==1
  title({['ERAI fat LEDIV, (W/M^2)  Streamlines based on U,V'] ...
     [,'beginning and ending dates for average:  ',TitleYearBanner]},'FontSize', 10);  
end
  
  %}
%temporary comment out title for figure otherwise above is the best
  %'ERAI full atmosphere  CURL calculated from U,V   Streamlines based on U,V'
  %    title({['Beginning and ending date for Avg.  ',PrintBegYear, ', ', PrintEndYear, ' Contours of EP mm/day  Vectors of U,V  lat long cells each ',PrintGridScale, ' deg.'] ...
  % title({['Beginning and ending date for Avg.  ',TitleYearBanner, ' Contours of Z kg/m lat long cells each ',PrintGridScale, ' deg.'] ...
   %   ,' www.abeqas.com/stochastic-landscapes/'},'FontSize', 8);
 %title({ 'To view more including ERA sourcing see www.abeqas.com/stochastic-landscapes/','FontSize', 8});
  % latest greatest outside of multi loop 
   %title([PrintYear,' 12 month average ', 'Z kg/m'],'FontSize', 14)
     %PngOutMeanNamestring = strcat(Pathstring2,FileAmean,begMonth);
     PngOutMeanNamestring = strcat(Pathstring2,FileAmean,TitleYearBanner,'.png');
  %needs repair maybe 7 aug 2021  
  saveas(gcf,PngOutMeanNamestring,'png');
 %()()()()()()()()  Print headers and files DONE ()()()()()()()()()()()() 
%}
%{
  % later I set testTop = stream2(Vqb,Vqc,fsxTop,fsyTop);
         plot(fsxTop,fsyTop, '*w');
   hTop1 = streamline(Vqb,Vqc,fsxTop,fsyTop);
   set(hTop1,'Color','white');
   set(hTop1,'LineWidth',0.5);
   % later I set testBottom = stream2(Vqb,Vqc,fsxBottom,fsyBottom);
      plot(fsxBottom,fsyBottom, '*w');
      hBottom1 = streamline(Vqb,Vqc,fsxBottom,fsyBottom);
   set(hBottom1,'Color','white');
   set(hBottom1,'LineWidth',0.5);
   % later I set testleft = stream2(Vqb,Vqc,fsxLeft,fsy); 
      plot(fsxLeft,fsy, '*w');
       hleft = streamline(Vqb,Vqc,fsxLeft,fsy);
   set(hleft,'Color','blue');
   set(hleft,'LineWidth',0.5);
   % later I set testLandVL = stream2(Vqb,Vqc,fsxLandVL,fsy);
%}
%&&&&&&&&&&&&&&&&&&&&&&&& Finally particle tracking &&&&&&&&&&&&&&&&&&&&&&&&&&&&
   %bestbestbest  
   set(gca,'DrawMode','fast')
 %best   streamparticles(testAll,1,'animate',1, 'FrameRate',20, 'ParticleAlignment','on'); %best one
 
    %streamparticles(testleft,1,'animate',1, 'FrameRate',20, 'ParticleAlignment','on'); %good one
 %streamparticles(testTop,1,'animate',1, 'FrameRate',20, 'ParticleAlignment','on'); %good one
 %streamparticles(testBottom,1,'animate',1, 'FrameRate',20, 'ParticleAlignment','on'); %good one
% streamparticles(testLandVL,1,'animate',1, 'FrameRate',20, 'ParticleAlignment','on'); %good one
 %streamparticles(testRight,1,'animate',1, 'FrameRate',20, 'ParticleAlignment','on'); %good one

  %streamparticles(testbullseye,24,'animate',1, 'FrameRate',200);
    % streamparticles(testright,24,'animate',1, 'FrameRate',200);
     % streamline(Vqb,Vqc,sxLeft,sy);
     %Rightline = (streamline(Vqb,Vq,sxRight,syRight));
  %set(Rightline,'Color','red');
  zVec = 0.0 * Vqc;
   %GEOPOTENTIAL HEIGHT (Z)  KG/M, EVAPORATION - PRECIPITATION (EP)   MM/DAY, Contours of T K kg/m^2
   %CURL
  %Contours of Z kg/m, Contours of EP mm/day, Contours of T K kg/m^2
  %Divergence of Latent Energy (LEDIV) W/m^2
 %end