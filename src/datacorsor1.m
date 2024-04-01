function c_info = datacorsor1( fig )
%% datacorsor1
% //    Description:
% //        -Get datacursor info
% //    Update History
% =============================================================
% 
dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','window','SnapToDataVertex','on','Enable','on')
w=waitforbuttonpress;
waitfor(w==0);
c_info = getCursorInfo(dcm_obj);
end

