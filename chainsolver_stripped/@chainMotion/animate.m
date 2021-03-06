%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% movie.m
% Written by Tarik Tosun
% Description:
%   writes a chainMotion to a specified.avi file.  Exactly the same as
%   animate.m, but writes to a file rather than displaying.
% Created 4/10/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function movie(varargin)
    %%% Arg Checking: %%%
    if(nargin < 1)
        error('At least one chainmotion needed.');
    end
    if(ischar(varargin{end}))
        if(nargin < 2)
            error('At least one chainmotion needed.');
        end
        saveMovie = 1;
    else
        saveMovie = 0;
    end
    %%%%%%%%%%%%%%%%%%%%%
    if(saveMovie)
        numobj = nargin-1;               % last arg is the filename.
        cmcell = varargin(1:end-1);
        fname = varargin{end};

        writerObj = VideoWriter(fname);
        open(writerObj);
    else
        numobj = nargin;
        cmcell = varargin;
    end

    chains = cell(1,numobj);	% chains in cell array.
    %{
    if(strcmp(chains{}.joints,'static_chain'))
        hists = cell(1,numobj);   %cell of cells, can be ep or angles.
    else
        angleHists = cell(1,numobj);
    end
    %}
    hists = cell(1,numobj);     %cell of cells, can be ep or angles.
    N = cmcell{1}.numFrames;
    L = 0;
    for j=1:numobj
        chains{j} = cmcell{j}.chain;
        if(strcmp(chains{j}.joints,'static_chain'))
            hists{j} = cmcell{j}.epHist;
        else
            hists{j} = cmcell{j}.angleHist;
        end
        if(cmcell{j}.numFrames ~= N)
            error('All chainMotions must have same numFrames.');
        end
        % axisLimits determined by longest chain:
        if(sum(chains{j}.lengths) > L)
            L = sum(chains{j}.lengths);
        end
    end

    % set plotting params:
    axisLimits = repmat([-1.05*L, 1.05*L], 1,3);
    %colors = {'blue','red','black','green','magenta','cyan','yellow'};
    colors = {[0 0 1], [1 0 0], [0 0 0], [0 1 0], [1 0 1], [0 1 1], [1 1 0]};
    nc = size(colors,2);

    %first frame:
    lines = cell(1,numobj);
    for j=1:numobj
        axis(axisLimits);
        chain = chains{j};
        if(strcmp(chains{j}.joints,'static_chain'))
            ep = hists{j};
            chain = setEPstatic(chain,ep{1});
        else
            angles = hists{j};
            chain = setJointAngles(chain,angles(1,:));
        end
        ep = chain.endpoints;
        lines{1,j} = line(ep(:,1),ep(:,2),ep(:,3),'Color',colors{mod(j,nc)},...
            'Marker','.','MarkerSize',20);
        %dots(j) = line(ep(:,1),ep(:,2),ep(:,3),'Color',colors{mod(j,nc)}..
        axis equal;
        xlabel('x'); ylabel('y'); zlabel('z');
        hold on;
    end
    %other frames:
    for i=1:N
        axis(axisLimits)
        for j=1:numobj
            chain = chains{j};
            if(strcmp(chains{j}.joints,'static_chain'))
                ep = hists{j};
                chain = setEPstatic(chain,ep{i});
            else
                angles = hists{j};
                chain = setJointAngles(chain,angles(i,:));
            end
            %angles = angleHists{j};
            %chain = setJointAngles(chain,angles(i,:));
            ep = chain.endpoints;
            set(lines{1,j}, 'xdata',ep(:,1),'ydata',ep(:,2),'zdata',ep(:,3));
            hold on;
        end
        refreshdata;
        drawnow;
        if(saveMovie)
            % write video:
            frame = getframe;
            writeVideo(writerObj,frame);
        end
    end
    if(saveMovie)
        close(writerObj);
        disp(['video written to ' fname]);
    end
end
