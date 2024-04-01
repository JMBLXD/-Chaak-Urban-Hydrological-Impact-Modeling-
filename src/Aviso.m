function aviso = Aviso(mensaje,tipo,icono)
%% Aviso
% //    Description:
% //        -Create msjbox
% //    Update History
% =============================================================
%
   CreateStruct.Interpreter = 'tex';
   CreateStruct.WindowStyle = 'modal';
   aviso = msgbox(mensaje,tipo,icono,CreateStruct);
end

