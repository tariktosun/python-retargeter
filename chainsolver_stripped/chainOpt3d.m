%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					OCTAVE VERSION 
%
% chainOpt3d.m
% Written by Tarik Tosun, USC Interaction Lab, 7/8/11
%
% Description: chainOpt3d finds the optimal (potential integral maximizing)
%   configuration of the given chain in the given chainField using the
%   specified optimization technique.  varargin is used for other
%   engine-specific parameters.
% Engines:
%   gradINT - parameters: spacing
%       Gradient-integral based optimizer.  Places limbs one by one, starting at the 
%       root of the chain.  Field gradient is evaluated at points along the
%       length of the chain, and summed to determine the sense of the
%       "moment" applied to the limb by the gradient.  Angles are
%       changed incrementally until a maxima is found.  spacing parameter
%       specifies the desired distance between points at which gradient is
%       evaluated.
%   gradEP - no parameters.
%       The same as gradOpt_INT, but the gradient is evaluated only at the
%       endpoints of each limb.
%   seq_sqp - parameters: spacing
%       Uses the sqp (sequential quadratic programming) function to
%       sequentially solve each limb.
%   seq_sqp_anon - parameters: spacing
%       Also uses sqp.  However, the field in this case in an anonymous
%       function.  To clarify:  the chainField argument to chainOpt3d in
%       this case is NOT a chainField3d object, it's an anonymous function.
%   simul_sqp_anon - parameters: spacing
%       This is a simultaneous solver, meaning that it finds a globally
%       optimal solution for the posematching problem.  Limbs positions are
%       solved simultaneously.  Uses the sqp solver, and an anonymous
%       function, like seq_sqp_anon.
%   objective_global_eef - paramenters: spacing, EEPotential
%       Simultaneous solver using an objective function consisting of two
%       potentials.  The first is a global skeleton integral.  The second
%       is an independant point charge attraction between the end
%       effectors.  EEPotential specifies the zero-distance potential of
%       the end effector.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newChain, fitParams] = chainOpt3d(chainField, source, chain, engine, varargin)
    % only sequential.m and simultaneous.m use fitparams.  source is passed
    % to these functions for fit evaluation.
    fitParams = struct([]);   % emtpy unless selected engine fills it.
    %%% Argument Checking %%%
    if(~ischar(engine))
        error('Unexpected engine string input.');
    elseif(~strcmp(class(chain),'chain3d'))
        error('Unexpected chain input.');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Engine selection
    if(strcmp(engine,'gradEP'))
        if(nargin~=3)
            error('gradEP - wrong number of arguments');
        elseif(~strcmp(class(chainField),'chainField3d'))
            error('Unexpected chainField input.');
        end
        newChain = gradOpt(chainField,chain,0);
    elseif(strcmp(engine,'gradINT'))
        if(nargin~=4)
            error('gradINT - wrong number of arguments');
        elseif(~strcmp(class(chainField),'chainField3d'))
            error('Unexpected chainField input.');
        end
        spacing = varargin{1};
        newChain = gradOpt(chainField,chain,spacing);
    elseif(strcmp(engine,'seq_sqp'))
        if(nargin~=4)
            error('seq_sqp: - wrong number of arguments');
        elseif(~strcmp(class(chainField),'chainField3d'))
            error('Unexpected chainField input.');
        end
        spacing = varargin{1};
        [newChain, fitParams] = sequential(chainField,source,chain,spacing,@optLink_sqp);
    elseif(strcmp(engine,'seq_sqp_anon'))
        if(nargin~=5)
            error('seq_sqp_anon: - wrong number of arguments');
        elseif(~strcmp(class(chainField),'function_handle'))
            error('Unexpected chainField input.  seq_sqp_anon requires function handle.');
        end
        spacing = varargin{1};
        [newChain, fitParams] = sequential(chainField,source,chain,spacing,@optLink_sqp);
    elseif(strcmp(engine,'simul_sqp_anon'))
        if(nargin~=5)
            error('simul_sqp_anon: - wrong number of arguments');
        elseif(~strcmp(class(chainField),'function_handle'))
            error('Unexpected chainField input.  simul_sqp_anon requires function handle.');
        end
        spacing = varargin{1};
        [newChain, fitParams] = simultaneous(chainField,source,chain,spacing);
    elseif(strcmp(engine,'objective_global_eef'))
        if(nargin~=7)
            error('objective_global_eef - wrong number of arguments');
        elseif(~strcmp(class(chainField),'function_handle'))
            error('Unexpected chainfield input.  objective_global_eef requires function handle.');
        end
        spacing = varargin{1};
        EEPotential = varargin{2};
        EELocation = varargin{3};
        [newChain, fitParams] = simultaneous(chainField,source,chain,spacing,EEPotential,EELocation);
    elseif(strcmp(engine,'angleMatch'))
        spacing = varargin{1};
        [newChain, fitParams] = angleMatch(source, chain, spacing);
        EEPotential = varargin{2};
    elseif(strcmp(engine, 'cost_joints_ee'))
        EEratio = varargin{1};
        spacing = 1;    %meaningless.
        [newChain, fitParams] = simultaneous([], source, chain,[], 'cost_joints_ee', EEratio);
    elseif(strcmp(engine, 'cost2_joints_ee'))
        EEratio = varargin{1};
        spacing = 1;    %meaningless.
        [newChain, fitParams] = simultaneous([], source, chain,[], 'cost2_joints_ee', EEratio);
    else
        error('Unexpected engine string input.');
    end
    
    % Set body and ee terms in fitParams:
        % NOTE:  will ONLY work for AFF's!  will error for matrix field!
        %        angles are transposed for functions b/c fmmincon.
    
    ep = endpoints(source);
    EELocation = ep(end,:);
    if(~exist('EEPotential','var')) %make EEPotential if not already defined.
        EEPotential = 500;
    end
    % just taking this out for now for static chains...
    %{
    if(~strcmp(source.joints,'static_chain'))
        fitParams.bodyPerfect = potIntegral_global_anon(source.joints.angles', source, spacing, chainField);
        fitParams.bodyActual = potIntegral_global_anon(newChain.joints.angles', newChain, spacing, chainField);
        fitParams.body_ratio = fitParams.bodyActual/fitParams.bodyPerfect;
        fitParams.EEPerfect = EE_objective(source.joints.angles', source, spacing,EEPotential, EELocation);
        fitParams.EEActual = EE_objective(newChain.joints.angles', newChain, spacing,EEPotential, EELocation);
        fitParams.EE_ratio = fitParams.EEActual/fitParams.EEPerfect;
    end
    %}
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    % gradOpt is the gradient-based optimizer engine.  Entering a
    % spacing of zero indicates that the endpoint-gradient method should be
    % used rather than an integral along the length of the limbs.
    function newChain = gradOpt(chainField, chain, spacing)
        %%% Constants %%%
        INC = pi/360;
        MAX_ITERATIONS = 200;
        
        [origin, lengths, pyAngleSeed] = olea(chain);		%OCTAVE EDIT
        numlinks = chain.numlinks;
        newEndpoints = chain.endpoints;
        
        ep = [0 0 0;origin];    %current limb endpoints.  In LEP format.
        py = [0,0];
        
        %if(spacing == 0)    %endpoint
            for n=1:numlinks
                %update py to move robot as a unit
                py = pyAngleSeed(n,:)+py;
                %update ep:
                ep = olea2lep3d(ep(2,:),lengths(n),py);
                %optimize this link:
                [ep,py] = optLink(ep,py,lengths(n),spacing,chainField,INC,MAX_ITERATIONS); %spacing = length.
                newEndpoints(n+1,:) = ep(2,:);
            end

        
        newChain = chain3d(newEndpoints);   %RETURN
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        
        
        % optLink optimizes the position of the given link in the given
        % field by riding the gradient.  Computes the gradient at only the
        % limb endpoint if spacing = length.
        function [epNew,pyNew] = optLink(ep,py,l,spacing,chainField,INC,MAX_ITERATIONS)            
            lastPYM = [0 0];
            for i=1:MAX_ITERATIONS
                disp(['iteration ' int2str(i) ': ' int2str(py)])
                gradi = gradIntegral(ep,spacing,chainField); %compute
                [py, lastPYM] = twiddlePY(ep,py,gradi,lastPYM,INC);
                if(all(lastPYM==0)) % stop at local minima for BOTH angles
                    break;
                end
                ep = olea2lep3d(ep(1,:),l,py);
            end
            epNew = ep;
            pyNew = py;
        end
        
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        
        % getGrad computes gradient integral for the given limb in the
        % given field.  If called with spacing = length, it computes the
        % gradient at only the endpoint of the limb.
        function gradi = gradIntegral(ep,spacing,chainField)
            mesh = chainField.mesh;
            [chainField, grad] = gradient(chainField);			%OCTAVE EDIT
            l = norm(ep(2,:)-ep(1,:));
            
            %mesh the limb:
            if(spacing == 0)		%spacing of zero indicates EP engine is being used.
                meshpoints = ep(2,:)';
            else
                lpoints = spacing:spacing:l;  %mesh distances along limb length.
                limbVect = ((ep(2,:)-ep(1,:))/l)'; %limb unit vector
                meshpoints = repmat(ep(1,:)',size(lpoints)) + kron(lpoints,limbVect);
            end
            
            %compute and sum gradients:
            gxi = sum(interp3(mesh{1},mesh{2},mesh{3},grad{1},...
                      meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
            gyi = sum(interp3(mesh{1},mesh{2},mesh{3},grad{2},...
                      meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
            gzi = sum(interp3(mesh{1},mesh{2},mesh{3},grad{3},...
                      meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
            gradi = {gxi, gyi, gzi};
        end
        
        % twiddlePY makes an incremental change to the pitch and yaw angles
        % of the limb based on the gradient it experiences.  
        function [newPY, lastPYM] = twiddlePY(ep,py,grad,lastPYM,INC)
            arm = ep(2,:)-ep(1,:);
            M = cross(arm,[grad{1} grad{2} grad{3}]);
            pitch = toRadians(py(1));
            yaw = toRadians(py(2));
            %project moment to pitch and yaw axes, split the increment:
            yawM = dot(M,[0 0 1]);    %yaw moment is about z-axis
            pitchM = -dot(M,[-sin(yaw),cos(yaw),0]); % pitch moment is about vect.
                                                % orthogonal to limb's projection
                                                % in the xy plane.
            projM = sqrt(yawM^2 + pitchM^2); %normal plane projection
            yawInc = abs(yawM/projM)*INC;
            pitchInc = abs(pitchM/projM)*INC;
            [pitch, lastPitchM] = twiddle(pitch,pitchM,lastPYM(1),pitchInc);
            [yaw, lastYawM] = twiddle(yaw,yawM,lastPYM(2),yawInc);
            newPY = toDegrees([pitch yaw]);
            lastPYM = [lastPitchM, lastYawM];
            
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
            
            % twiddle function is adapted from twiddleAngle in
            % chainFieldOpt.m (for 2d), and increments the passed angle by
            % inc if it experiences a positive/negative moment.
            function [newAngle, lastM] = twiddle(angle,M,lastM,inc)
                if(M>0)
                    if(lastM>=0)
                        newAngle = angle + inc;
                        lastM = M;
                    else
                        lastM = 0;
                        newAngle = angle - inc ; %don't move
                        return;
                    end
                elseif(M<0)
                    if(lastM<=0)
                        newAngle = angle - inc;
                        lastM = M;
                    else
                        lastM = 0;
                        newAngle = angle - inc;
                        return;
                    end
                else %if there's zero moment, just stop.
                    lastM = 0;
                    newAngle = angle;
                    return;
                end          
            end
        end      
    end
end