function walog_load_species(hemi)
global handl
global GPS

if isequal(hemi,'auto')
    hemi='north';
    if isfield(GPS,'latitude') && GPS.latitude<0; 
        hemi='south';
    end
end

if isfield(handl,'hemi') && isequal(handl.hemi,hemi) return; end

hemi

if isequal(hemi,'north')
    sfid=fopen('species_list_north.txt');
    im=imread('images/arctic.jpg');
elseif isequal(hemi,'south')
    sfid=fopen('species_list_south.txt');
    im=imread('images/antarctica.jpg');
else
    error(' no hemisphere defined');
end

handl.hemi=hemi;
imagesc(im,'Parent',handl.axes2);
%cmap=colormap(handl.axes2,'gray');
axis(handl.axes2,'off');
C = textscan(sfid, '%d%s%s','Delimiter',',');
nums=C{1};
realnames=C{2};
scinames=C{3};
valid1=length(find(nums==1));
fclose(sfid);
for l=1:length(handl.species1buttons)
    hs=1;
    while ~strcmp(get(handl.species1buttons(hs),'tag'),['spec_button_' num2str(l)])
        hs=hs+1;
    end
    if l>valid1 && strcmp(get(handl.species1buttons(l),'String'),'species1')
        set(handl.species1buttons(l),'String','invalid','visible','off');
        %set(species1buttons(end-l+1),'String','invalid');
    end;
    for k=1:length(nums)
        if nums(k)==1 && isempty(char(realnames(k))) && ( strcmp(get(handl.species1buttons(hs),'String'),'species1') || ~strcmp(get(handl.species1buttons(hs),'String'),'other:') )
            set(handl.species1buttons(hs),'String','invalid','visible','off');
            char(realnames(k));
            break;
        elseif nums(k)==1 && ( strcmp(get(handl.species1buttons(hs),'String'),'species1')|| ~strcmp(get(handl.species1buttons(hs),'String'),'other:') )
            char(realnames(k));
            set(handl.species1buttons(hs),'String',char(realnames(k)),'TooltipString',char(scinames(k)),'Callback','walog_button_Callback');
            nums(k)=0;
            break
        else
            %error('hihi')
            continue
        end
    end
end


%generate new figure im there are still species left

pos1=find(nums==1);
valid1=length(pos1);
if valid1>0
    col=5;
    row=ceil(valid1/col);
    rw=0;
    co=0;
    handl.species1extension=figure(3);
    
    wi=1280;
    he=800;
    set(handl.species1extension,'Position',[ 1 1 wi he],'Name','Species1','Toolbar','none','MenuBar','none','NumberTitle','off');
    species1extensionBG = uibuttongroup('Title','Species1ext');
    for k=1:valid1
        
        handl.species1ext(k).H=uicontrol('style','togglebutton','FontSize',14,'units','normalized','position',[co/col rw/row 1/col 1/row],'string',char(realnames(pos1(k))),'TooltipString', char(scinames(pos1(k))),'Parent',species1extensionBG);
        co=co+1;
        if mod(k,col)==0, rw=rw+1;co=0; end;
    end
    for k=1:valid1
        set(handl.species1ext(k).H,'Callback','walog_button_Callback');
    end;
    %set(species2extensionBG,'SelectionChangeFcn',@walog_button_Callback);
    set(species1extensionBG,'SelectedObject',[]);  % No selection
    % set(species2extensionBG,'Visible','on');
end
set(handl.species1extension,'Visible','off');
