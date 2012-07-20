% draw.m, Tarik Tosun
% for use with chain3d class
% created 7/18/11

% Draw method uses plot3 to draw the chain to the active figure.
% varargin is for plotting options.
function draw(obj,varargin)
    %%% Constants %%%
    EDGEBUFFER = 0.5;  %edge buffer, in percent
    %%% Arg Handling %%%
    switch(nargin)
        case 1
            plotFormatting = {''};
        case 0
            error('Unexpected Inputs');
        otherwise
            plotFormatting = varargin;
    end
    %%%%%%%%%%%%%%%%%%%%%
    
    limits = (1+EDGEBUFFER)*extent(obj);	%OCTAVE EDIT
    for i=1:size(limits,1)  %axis limits can't be [0 0]
        if(all(limits(i,:)==[0 0]))
            limits(i,:)=[-1 1];
        end
    end
    hold on;
    plot3(obj.endpoints(:,1),obj.endpoints(:,2),...
          obj.endpoints(:,3),plotFormatting{:},'Marker','.','MarkerSize',20);
%    axis([limits(1,:), limits(2,:), limits(3,:)]); 
end