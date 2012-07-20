%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rightArm3d.m
% Written by Tarik Tosun
% Description:
%   Grabs 3d position right arm data from kinect .oni file filename.  Based
%   on rightArm.m, which grabs 2d pixel data.
%   If the name of a file is passed as the second arg, it will output .avi
%   to this file.
% Created 4/14/12
% Edited 4/25/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [chainmotion] = rightArm3d(varargin)



    [x3hist, y3hist, z3hist] = grabHist3d(varargin{:});
    % transform to static base:
    basex = x3hist(:,1);
    basey = y3hist(:,1);
    basez = z3hist(:,1);
    xt = x3hist - repmat(basex,1,4);
    yt = y3hist - repmat(basey,1,4);
    zt = z3hist - repmat(basez,1,4);

    % create chainMotion with static chain
    N = size(xt, 1);
    epHist = cell(1,N-1);
    for i=1:N-1 %trim zeros at end (wierd...)
        ep = [xt(i,:)', yt(i,:)', zt(i,:)'];
        epHist{i} = ep;
    end
    ep = [xt(1,:)', yt(1,:)', zt(1,:)'];    %set to first
    chain = chain3d(ep,'static_chain');
        
    chainmotion = chainMotion(chain, epHist);


%function [lengths, angles] = rightArm(xt,yt)

 %  [lengths angles] = parseToLA(xt,yt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%                       Subfunctions                    %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% grabHist3d gets the history in pixel format, as a 3x1 cell of 4 element
% wide arrays (xyz).  Also plots the xy pixel format over the source video.
    function [x3hist, y3hist, z3hist] = grabHist3d(varargin)
    %    addpath('Mex')
    %    SAMPLE_XML_PATH='Config/SamplesConfig.xml';
        addpath('Kinect_Matlab/Mex');
        SAMPLE_XML_PATH='Kinect_Matlab/Config/SamplesConfig.xml';

                % arg handling:
        if(nargin==1)
            filename = varargin{1};
            saveMovie= 0;
        elseif(nargin==2)
            filename = varargin{1};
            outName = varargin{2};
            saveMovie = 1;
        else
            error('must have 1 or 2 arguments');
        end

        if(saveMovie)
            writerObj = VideoWriter(outName);
            open(writerObj);
        end

        % Start the Kinect Process
        %filename='Example/SkelShort.oni';
        KinectHandles=mxNiCreateContext(SAMPLE_XML_PATH,filename);

        figure,
        Pos= mxNiSkeleton(KinectHandles); 
        I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
        h=imshow(I);

        while(Pos(1)==0);
            %disp('searching...');
            mxNiUpdateContext(KinectHandles);
            I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
            Pos= mxNiSkeleton(KinectHandles); 
            set(h,'Cdata',I); drawnow;
        end

        x3hist = zeros(109,4);
        y3hist = zeros(109,4);
        z3hist = zeros(109,4);

        hh=zeros(1,3);
        n = 1;
        while(Pos(1)>0)
            mxNiUpdateContext(KinectHandles);
            I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
            set(h,'Cdata',I); drawnow;
            Pos= mxNiSkeleton(KinectHandles,1); 
            if(hh(1)>0);
                for i=1:3, delete(hh(i)); end
            end

            hold on
            y=Pos(1:15,7);
            x=Pos(1:15,6);
            rhx = x(2:5);
            rhy = y(2:5);
            
            x3 = Pos(1:15,3);   y3 = Pos(1:15,4);   z3 = Pos(1:15,5);
            rhx3 = x3(2:5);     rhy3 = y3(2:5);     rhz3 = z3(2:5);

            hh(1)=plot(rhx, rhy,'r.');
            hh(2)=plot(rhx,rhy,'b');
            hh(3)=plot(rhx(1),rhy(1),'g.');
            drawnow;
            if(saveMovie)
                % write video:
                frame = getframe;
                writeVideo(writerObj,frame);
            end

            x3hist(n,:) = rhx3';
            y3hist(n,:) = rhy3';
            z3hist(n,:) = rhz3';
            n = n+1;
        end
        if(saveMovie)
            close(writerObj);
            disp(['video written to ' outName]);
        end
        mxNiDeleteContext(KinectHandles);
    end
end