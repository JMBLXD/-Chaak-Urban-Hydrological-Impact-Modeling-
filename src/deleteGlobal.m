function deleteGlobal(estado)
    if strcmp(estado,'parcial')
        clearvars('-global','-except','ProyectoHidrologico','modelo','idioma')
    else
        clearvars('-global')
    end
end