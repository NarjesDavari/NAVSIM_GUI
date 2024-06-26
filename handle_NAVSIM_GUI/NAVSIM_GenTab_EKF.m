function Tab = NAVSIM_GenTab_EKF(Scan_Result)

for I=1:length(Scan_Result.titles)
    Tab{1,I} = Scan_Result.titles{I};
    Tab{2,I} = Scan_Result.units{I};    
    for J=1:size(Scan_Result.Tab,1)
        Tab{2+J,I} = Scan_Result.Tab(J,I);
    end
end