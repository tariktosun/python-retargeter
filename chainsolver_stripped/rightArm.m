%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rightArm.m
% Written by Tarik Tosun
% Description:
%   Grabs right arm data from kinect .oni file filename.
% Created 3/19/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [chainmotion] = rightArm(filename)
    [xhist, yhist] = grabHist(filename);
    % transform to static base:
    basex = xhist(:,1);
    basey = yhist(:,1);
    xt = xhist - repmat(basex,1,4);
    yt = yhist - repmat(basey,1,4);

%function chainmotion = rightArm(xt,yt)

    %flip sense for plotting.
    %yt = -yt;   
    [lengths angles] = parseToLA(xt,yt);

    meanLengths = mean(lengths,1);
    chain = chain3d([0 0 0], meanLengths, {'foo','bar','baz'}, ...
            [-180 -180 -180], [180 180 180], '2D_simple');
        
    chainmotion = chainMotion(chain, angles);


%function [lengths, angles] = rightArm(xt,yt)

 %  [lengths angles] = parseToLA(xt,yt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%                       Subfunctions                    %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [lengths, angles] = parseToLA(xt,yt)
        N = size(xt,1);
        lengths = zeros(N,3);
        angles = zeros(N,3);
        for j=1:N
            ep = [xt(j,:)' zeros(size(xt(j,:)')) yt(j,:)'];
            [o l a] = simpleIK(ep);
            lengths(j,:) = l';
            angles(j,:) = a';
        end     
    end



% grabHist gets the history in pixel format, as a 2x1 cell of 4 element
% wide arrays (x and y).
    function [xhist, yhist] = grabHist(filename)
    %    addpath('Mex')
    %    SAMPLE_XML_PATH='Config/SamplesConfig.xml';
        addpath('Kinect_Matlab/Mex');
        SAMPLE_XML_PATH='Kinect_Matlab/Config/SamplesConfig.xml';

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

        xhist = zeros(109,4);
        yhist = zeros(109,4);

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

            hh(1)=plot(rhx, rhy,'r.');
            hh(2)=plot(rhx,rhy,'b');
            hh(3)=plot(rhx(1),rhy(1),'g.');
            drawnow

            xhist(n,:) = rhx';
            yhist(n,:) = rhy';
            n = n+1;
        end

        mxNiDeleteContext(KinectHandles);
    end
end