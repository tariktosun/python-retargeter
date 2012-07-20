function fieldtester
    myChain = chain3d([0 0 0; 1 0 0; 1 1 0]);
    af = anonfield(myChain,100);
    poti = zeros(1,2);
    
    p = zeros(1,19);
    y = 0:10:180;
    
    for i=1:size(p,2)    
        mySeed = chain3d([0 0 0], [1;1], [0 0; p(i) y(i)]);
        [o l a] = olea(mySeed);
        %{
        o1 = [1 0 0];
        l1 = 1;
        a1 = [p(i) y(i)];
        %}
        %hold on; draw(mySeed)
        poti(i,:) = potIntegral_global_anon(o,l,a,0.1,af);
        %poti2(i) = potIntegral_global_anon(o1,l1,a1,0.1,af);
    end
end